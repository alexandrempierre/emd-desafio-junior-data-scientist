__author__ = 'Alexandre Pierre'
__email__ = 'alexandrempierre [at] gmail [dot] com'


import functools as ft
import operator as op
import streamlit as st
import pandas as pd
import dados


df_chamado_1746 = dados.chamado_1746()
df_chamado_1746['data_inicio_date'] = pd.to_datetime(df_chamado_1746['data_inicio']).dt.normalize()
df_bairro = dados.bairro()
df_eventos = dados.eventos()

df_chamado_bairro = df_chamado_1746.merge(
    df_bairro, how='inner', on='id_bairro'
)
dfs_chamado_evento = []
df_chamado_evento : pd.DataFrame
df_chamado_data = df_chamado_1746
df_chamado_data['data_inicio_date'] = pd.to_datetime(df_chamado_1746['data_inicio']).dt.normalize()
for index, row in df_eventos[['data_inicial', 'data_final', 'evento']].iterrows():
    maior_que_inicio = row['data_inicial'] <= df_chamado_1746['data_inicio_date']
    menor_que_fim = df_chamado_1746['data_inicio_date'] <= row['data_final']
    dentro_do_intervalo = menor_que_fim & maior_que_inicio
    temp_df = df_chamado_data[dentro_do_intervalo]
    temp_df['evento'] = row['evento']
    dfs_chamado_evento.append(temp_df)
df_chamado_evento = pd.concat(dfs_chamado_evento)

# st.write('Hello World!')
# st.table(df_chamado_1746.head())
st.title('Visão de bairro')
bairro = st.selectbox(
    'Bairro',
    options=df_bairro['nome'].drop_duplicates().sort_values(),
)
st.line_chart(
    df_chamado_bairro[df_chamado_bairro['nome'] == bairro] \
        .groupby(['data_inicio_date']) \
        .count()[['id_chamado']] \
        .rename(columns={'id_chamado': f'chamados em {bairro}'})
)
tipo_ocorrencia = st.selectbox(
    'Tipo de Ocorrência',
    options=df_chamado_1746['tipo'].drop_duplicates().sort_values()
)
bairro_correto = df_chamado_bairro['nome'] == bairro
tipo_correto = df_chamado_bairro['tipo'] == tipo_ocorrencia
st.bar_chart(
    df_chamado_bairro[bairro_correto & tipo_correto] \
        .groupby(['subtipo']) \
        .count()[['id_chamado']] \
        .rename(columns={'id_chamado': f'chamados em {bairro}'})
)

st.title('Ocorrências por dia em cada Evento')
st.area_chart(
    df_chamado_evento \
        .groupby(['data_inicio_date', 'evento'], as_index=False) \
        .count()[['data_inicio_date', 'evento', 'id_chamado']] \
        .rename(columns={'id_chamado': 'ocorrencias'}) \
        .pivot_table(
            values='ocorrencias',
            columns='evento',
            index='data_inicio_date',
            aggfunc=lambda x: x
        ) \
        .fillna(0)
)
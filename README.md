# Rodando o projeto

Antes de começar, é necessário fornecer um id de projeto para que os dados possam ser baixados do Google Cloud Platform, basta renomear o arquivo `.env.example` para `.env` e preencher a única variável contida nele.

0. para ter acesso a um ambiente isolado, pode ser interessante criar um ambiente isolado com `conda` ou `venv`, recomendo o último:

### Windows

```
python -m venv .venv
.venv\Scripts\activate
```

### Linux

```
python -m venv .venv
source .venv/bin/activate
```

1. independente do uso ou não de ambiente isolado, é necessário baixar os pacotes python usados no projeto:

```
pip install -r requirements.txt
```

2. nesse momento já se pode rodar o notebook `analise_pandas.ipynb`, recomendo fazê-lo antes de testar a visualização para gerar os arquivos locais com os dados que também serão usados na visualização e cujo download pode demorar um pouco

3. para abrir a visualização do streamlit basta rodar o arquivo `main.py`:

```
python main.py
```

import os
import subprocess


if __name__ == '__main__':
    subprocess.Popen(["streamlit", "run", 'streamlit_app.py', os.devnull])
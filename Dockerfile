FROM python:3.8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
WORKDIR /code
RUN pip install pipenv
COPY Pipfile Pipfile.lock /code/
RUN pipenv install --system
ENV FLASK_APP app.py
ENV FLASK_RUN_HOST 0.0.0.0

COPY . .
#CMD ["flask", "run"]


# assuming repo is up to date on host machine
RUN apt update -y && apt-get install -y \
    build-essential \
    vim \
    libicu-dev \
    build-essential \
    libpcre3 \
    libpcre3-dev && \
    pip install pip --upgrade


# create unprivileged user
RUN adduser --disabled-password --gecos '' myuser  

# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

# install chromedriver
RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# set display port to avoid crash
ENV DISPLAY=:99
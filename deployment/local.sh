#This image runs Cape :
# You can run cape in 3 different modes :
# * Standalone :    docker run ...
# * As a Master,Scheduler and Worker(s):
#   * Master:       docker run ...
#   * Scheduler:    docker run ...
#   * Worker(s):    docker run ...

#git config --global user.email "edwardmjackson@gmail.com"
#git config --global user.name "Ed Jackson"


sudo apt-get -y update && \
    apt-get install -y python-dev python3-dev python3-pip git zlib1g-dev\
                       apt-transport-https ca-certificates wget build-essential\
                       libcurl4-openssl-dev g++ htop nano parallel curl locales\
                       daemontools unzip python3-distutils && \
    apt-get clean

pip3 install --upgrade pip setuptools dumb-init ipython

# Ensure that we always use UTF-8 and with US English locale
locale-gen en_US.UTF-8
export LC_ALL="en_US.UTF-8"
export locale-gen="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export PYTHONIOENCODING="utf-8"

#Add non-root user to run app
sudo useradd -G users -m runner

#Argument to rebuild from this point after an update

pip3 install -vv --upgrade git+https://github.com/edwardmjackson/cape-frontend
pip3 install -vv --upgrade git+https://github.com/edwardmjackson/cape-webservices

#Run model tests to automatically download latest standard production model
# pytest -vs --pyargs cape_document_qa.tests
# EXPOSE 5050
# EXPOSE 5051

#Default configuration
export PORT=5050
export FRONTEND_PORT=5051
#ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]


########################################
## CAPE DEFAULT ENVIRONMENT VARIABLES ##
########################################

# cape-webservices Environment variables:

export CAPE_WEBSERVICE_HOST="0.0.0.0"
export CAPE_WEBSERVICE_PORT=5050
# Max request size will be 100 megabytes
export CAPE_WEBSERVICE_REQUEST_MAX_SIZE=100000000
# request timeout is 10 mins
export CAPE_WEBSERVICE_REQUEST_TIMEOUT=600
# graceful shutdown times out in 3 seconds
export CAPE_WEBSERVICE_GRACEFUL_SHUTDOWN_TIMEOUT=3
# Websocket max size is 1 MB
export CAPE_WEBSERVICE_WEBSOCKET_MAX_SIZE=1000000
export CAPE_WEBSERVICE_WEBSOCKET_MAX_QUEUE=32
export CAPE_WEBSERVICE_MAX_NUM_ANSWERS=50
export CAPE_HOSTNAME=DEV_SERVER
# max size of inline text will be 150000 characters:
export CAPE_WEBSERVICE_MAX_SIZE_INLINE_TEXT=150000


# cape-responder Environment variables:
export CAPE_CLUSTER_SCHEDULER_IP=127.0.0.1
export CAPE_CLUSTER_SCHEDULER_PORT=8786
export CAPE_NUM_WORKERS_PER_REQUEST=8

# cape-document-qa Environment variables:

export CAPE_MODELS_FOLDER="os.path.join(THIS_FOLDER, 'storage', 'models')"
export CAPE_MODEL_FOLDER="os.path.join(MODELS_FOLDER, 'production_ready_model')"
export CAPE_MODEL_URL=https://github.com/bloomsburyai/cape-document-qa/releases/download/v0.1.2/production_ready_model.tar.xz
export CAPE_MODEL_MB_SIZE=422
export DOWNLOAD_ALL_GLOVE_EMBEDDINGS=False
export CAPE_GLOVE_EMBEDDINGS_URL=https://nlp.stanford.edu/data/glove.840B.300d.zip
export CAPE_LM_URL=https://github.com/bloogram/cape-document-qa/releases/download/v0.1.2/lm.tar.bz2


# cape-document-manager Environment variables:
#
export CAPE_SPLITTER_WORDS_PER_CHUNK=500
export CAPE_SPLITTER_WORDS_OVERLAP_BEFORE=50
export CAPE_SPLITTER_WORDS_OVERLAP_AFTER=50
export CAPE_LOCAL_UNPICKLING_LRU_CACHE_MAX_SIZE=50000
export CAPE_SQLITE_PATH=os.path.join(THIS_FOLDER, 'storage', 'bla.sqlite')
export CAPE_SQLITE_JOURNAL_MODE=wal
#  cache size in kibibytes (64 megibytes)
export CAPE_SQLITE_CACHE_SIZE=-65536


# cape-userdb Environment variables:

export CAPE_USERDB_SQLITE_PATH="os.path.join(THIS_FOLDER, 'storage', 'capeusers.sqlite'))"


# cape-api-helpers Environment variables:

export CAPE_SECRET_DEBUG_KEYWORD debug7373
export CAPE_SECRET_EXTRA_INFO_KEYWORD trail8hef89


# cape-slack-plugin Environment variables:

export CAPE_SLACK_CLIENT_ID REPLACEME
export CAPE_SLACK_CLIENT_SECRET REPLACEME
export CAPE_SLACK_VERIFICATION REPLACEME
export CAPE_SLACK_APP_URL REPLACEME


# cape-facebook-plugin Environment variables:

export CAPE_FACEBOOK_VERIFICATION REPLACEME


# cape-hangouts-plugin Environment variables:

export CAPE_HANGOUTS_VERIFICATION REPLACEME


# cape-email-plugin Environment variables:
#
export CAPE_MAILGUN_API_KEY REPLACEME
export CAPE_MAILGUN_DOMAIN REPLACEME
export CAPE_DEFAULT_EMAIL REPLACEME


# cape-frontend Environment variables:

export CAPE_FRONTEND_CREATE_DEMO_ACCOUNT_ON_INIT True
export CAPE_FRONTEND_WAIT_FOR_BACKENDS True
export CAPE_FRONTEND_ACTIVATE_NGROK_LINUX True

python3 -m cape_webservices.run $PORT & python3 -m cape_frontend.run $FRONTEND_PORT

#docker stop my_service;docker rm my_service;docker build -t my_service_image -f deployment/Dockerfile . && docker run -ti --ulimit core=0:0 --user runner --rm -v $(pwd)/..:/mnt --name my_service my_service_image

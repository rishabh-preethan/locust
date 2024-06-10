FROM node:18.0.0-alpine as webui-builder

ADD locust/webui locust/webui
ADD package.json .

RUN yarn webui:install --production --network-timeout 60000

RUN yarn webui:build

FROM python:3.11-slim as base

FROM base as builder
RUN apt-get update && apt-get install -y git 
# there are no wheels for some packages (geventhttpclient?) for arm64/aarch64, so we need some build dependencies there
RUN if [ -n "$(arch | grep 'arm64\|aarch64')" ]; then apt install -y --no-install-recommends gcc python3-dev; fi
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY . /build
WORKDIR /build
RUN pip install .

FROM base
COPY --from=builder /opt/venv /opt/venv
COPY --from=webui-builder locust/webui/dist locust/webui/dist
COPY locustfile.py /home/locust/locustfile.py
ENV PATH="/opt/venv/bin:$PATH"
# turn off python output buffering
ENV PYTHONUNBUFFERED=1
RUN useradd --create-home locust
# ensure correct permissions
RUN chown -R locust /opt/venv
RUN chown locust /home/locust/locustfile.py
USER locust
WORKDIR /home/locust
EXPOSE 8089 5557
ENTRYPOINT ["locust"]

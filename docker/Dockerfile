FROM ruby:slim
RUN apt-get update && apt-get install -y curl
RUN groupadd -g 999 appuser && \
useradd -r -u 999 -g appuser appuser
USER appuser
EXPOSE 80
COPY http_server.rb .
CMD ruby http_server.rb

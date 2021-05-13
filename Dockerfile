FROM ruby:slim
EXPOSE 80
COPY http_server.rb .
CMD ruby http_server.rb

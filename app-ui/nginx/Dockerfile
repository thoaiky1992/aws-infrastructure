FROM nginx:stable-alpine

# Cài đặt envsubst
RUN apk add --no-cache gettext

# Copy tệp cấu hình Nginx mẫu vào image
COPY app.conf /etc/nginx/conf.d/app.conf.template

EXPOSE 80

# Thay thế các biến môi trường trong tệp cấu hình Nginx khi container khởi động
CMD ["sh", "-c", "\
  PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4) && \
  export PRIVATE_IP && \
  envsubst '${BACKEND_URL} ${PRIVATE_IP}' < /etc/nginx/conf.d/app.conf.template > /etc/nginx/conf.d/app.conf && \
  cat /etc/nginx/conf.d/app.conf && \
  nginx -g 'daemon off;'"]
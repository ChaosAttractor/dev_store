FROM minio/minio

#HEALTHCHECK --interval=30s --timeout=20s \
#  CMD curl -f http://localhost:9000/minio/health/live || exit 1

CMD ["minio", "server", "/data", "--console-address", ":9001"]

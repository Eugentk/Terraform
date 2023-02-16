[
  {
    "name": "${container_name}",
    "image": "${docker_image_url}",
    "essential": true,
    "links": [],
    "command": ["/bin/sh", "-c", "run script.sh"],
    "portMappings": [
          {
            "containerPort": 8080,
            "hostPort": 8080,
            "protocol": "tcp"
          }
        ],
    "environment": [
          {
           "name": "DATABASE_URL",
           "value": "${database_url}"
          },
          {
           "name": "POSTGRES_USERNAME",
           "value": "${postgres_username}"
          },
          {
           "name": "POSTGRES_PASSWORD",
           "value": "${postgres_password}"
          },
          {
           "name": "POSTGRES_HOST",
           "value": "${postgres_host}"
          },
          {
           "name": "POSTGRES_PORT",
           "value": "${postgres_port}"
          },
          {
           "name": "POSTGRES_DB",
           "value": "${postgres_db}"
          }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "app-log-stream"
      }
    }
  }
]

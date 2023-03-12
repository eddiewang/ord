# Use a small, secure base image
FROM rust:1.67.1-alpine AS build

# Set up the working directory
WORKDIR /app

# Copy the application source code
COPY . .

# Install any necessary dependencies
RUN apk add --no-cache musl-dev openssl-dev curl

# Build the application with optimized release settings
RUN cargo build --release

# Start a new stage using a smaller base image
FROM alpine:3.14

# add for init
RUN apk add --no-cache curl

# Set up the working directory and copy the built binary
WORKDIR /app
COPY --from=build /app/target/release/ord .

# Set the application to run as a non-root user
RUN adduser -S orduser
USER orduser

# Expose the necessary port
EXPOSE 80

# Start the application
CMD ["./ord"]



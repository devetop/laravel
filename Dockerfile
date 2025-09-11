FROM webdevops/php-nginx:8.2-alpine

# Copy configuration files
COPY ./config/php.ini /opt/docker/etc/php/php.ini
COPY ./config/vhost.conf /opt/docker/etc/nginx/vhost.conf

WORKDIR /app

# Create Laravel project
RUN composer create-project laravel/laravel . --remove-vcs --prefer-dist

# Copy application files (excluding what's in .dockerignore)
# COPY . .

# Set permissions
RUN chown -R application:application /app
RUN chmod -R 775 storage bootstrap/cache

# Generate application key
RUN cp .env.example .env && \
    php artisan key:generate

# Optimize Laravel
RUN php artisan optimize:clear && \
    php artisan optimize

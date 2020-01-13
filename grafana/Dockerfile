FROM grafana/grafana

COPY grafana.ini /etc/grafana/
COPY ./datasource_prometheus.yml /etc/grafana/provisioning/datasources/ 
COPY ./dashboards.yml /etc/grafana/provisioning/dashboards/
COPY dashboards/*.json /var/lib/grafana/dashboards/

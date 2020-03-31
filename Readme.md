# Déployment et Configuration d'Elasticsearch

## Ce dépot permet de faire le déploiement d'un cluster Elasticsearch à l'aide de  containers Docker

>Une instance de Kibana est également déployée pour visualiser les données de la base de données Elasticsearch déployée.

## Pour faire le monitoring du cluster, la solution proposée utilise Prometheus, Node-exporter, Cadvisor et Grafana

## Prometheus

>Le dossier `prometheus/` contient deux fichier liés à l'utilisation de prometheus. Le fichier `prometheus.yml` contient la configuration du serveur prometheus, qui va ***scrapper*** les metrics des containers spécifiés, soit cadvisor et node-exporter. Ainsi, Prometheus pourra recueillir les métriques des conteneurs et ceux de l'hôte.

De plus, un fichier alert.rules.yml permet de définir des règle pour que Prometheus lance des alertes. Dans l'alerte définie ici, si un conteneur a une utilisation totale cpu plus de 50% d'un cpu, alors le 
## Grafana

>Un dashboard `elasticsearch-ds.json` permettant de visualiser les métriques des containers du cluster ElasticSearch en plus des métriques de l'hôte du système est fourni dans le dossier `/grafana/dashboards/`. Il est automatiquement ajouté à Grafana lors du déploiement du container. Cependant, comme ce dashboard est ***provisionned***, ses changements ne sont pas sauvegardable à travers le UI de Grafana. Pour sauvegarder les changements, il faudrait exporter le JSON du dashboard et l'ajouter au code source du déploiement, à la place du fichier `/grafana/dashboards/elasticsearch-ds.json`.

> Un fichier de configuration des datasources est fourni dans le dossier
`grafana/datasources/datasources.yml`. Ce fichier permet de configurer automatiquement la connexion entre Grafana et Prometheus. Ainsi, le dashboard `elasticsearch-ds.json` est fonctionnel dès le déploiement du conteneur de Grafana.

## `Dockerfile` et `docker-compose.yaml`

Le `Dockerfile` déclaré ici ne sert qu'à injecter un agent JProfiler dans un des nodes du cluster Elasticsearch déployé.  Ainsi, cette image n'est utilisé que pour un seul node du cluster (le container es01).image modifiée. Pour construire l'image, simplement exécuter la commande:

>`docker image build . -t elasticsearch-jprofiler`

Ensuite, pour déployer Elasticsearch, Kibana,  ainsi que la solution de monitoring composée de Prometheus et Grafana, il suffit de lancer la commande suivante à partir du répertoire contenant le fichier docker-compose.yaml :
>`docker-compose up -d`
Cette commande lance le cluster en utilisant le mode "detached" de Docker.

## Scaling

Grâce au Dashboard Grafana `elasticsearch-ds.json` il est possible de visualiser les métrics d'utilisation des containers d'Elasticsearch. En cas de surcharge, on peut scaler le nombre de container d'Elasticsearch à l'aide de la commande:

> `docker-compose up --scale es02=2`

Cette commande déploie un second container basé sur le service `es02` défini  le fichier `docker-compose.yaml`

Pour réduire le nombre de node, simplement utiliser la même commande que précédemment, mais avec un nombre de container plus petit:
> `docker-compose up --scale es02=1`# elasticsearch-deployment

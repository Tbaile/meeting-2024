---
theme: default
title: TBA
drawings:
  persist: false
  presenterOnly: true
transition: slide-left
mdc: true
overviewSnapshots: true
monaco: false
---

# TBA

Un piccolo passo per l'uomo...

---
layout: section
---

# Cos'è un container?

---
layout: quote
---

# A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another.

_**Fonte:** [Docker](https://www.docker.com/resources/what-container)_

### Di fatto, un container è un modo per isolare un'applicazione e le sue dipendenze in un ambiente controllato e riproducibile.

<!-- Pensatela un po' come una macchina virtuale, ma che gira un solo -->

---

# Perché usare i container?

Cosa ci spinge a usare tale tecnologia?

- **Isolamento**: ogni container è isolato dagli altri
- **Riproducibilità**: un container è riproducibile ovunque
- **Portabilità**: un container può girare ovunque

<div class="px-25 pt-3">
  <img src="./assets/container_vs_vm.png" />
</div>

---
layout: statement
---

## Il 90% delle applicazioni di cui abbiamo necessità sono già fruibili attraveso i container.

<div class="flex gap-4 justify-center text-4xl my-3">
  <v-clicks>
    <logos-ubuntu />
    <logos-drupal-icon />
    <logos-python />
  </v-clicks>
</div>

<v-click>

## Quasi tutte le applicazioni che si pubblicano ora, come primo metodo di deploy consigliano l'uso dei container.

</v-click>

---

# Come funzionano i container?

Un container è approssimabile a una macchina virtuale, ma con alcuni punti chiave:

- Hanno un' immagine di partenza, la quale è la parte statica del container
- La persistenza si ottiene tramite i volumi (storage apposito o cartelle)
- Si possono esporre delle porte per comunicare con l'esterno
- Si possono passare delle variabili d'ambiente e si possono passare dei file

<!--
Accennare cosa sono i volumi, di fatto storage persistente che viene agganciato direttamente al container

Non solo le porte si possono usare, anche intere reti virtuali

Possiamo configurare il container con variabili d'ambiente o con appunto dei volumi
 -->

---
layout: section
---

# Come si crea un container?

---

# Bellissima introduzione, ma come si fa?

Io ho già la mia app...

Bisogna analizzare la nostra applicazione e capire quali sono le sue necessità:

- **Runtime**: quale runtime necessita la nostra applicazione? PHP, Python, Node.js, Java...
- **Dipendenze**: quali dipendenze necessita la nostra applicazione? Software, librerie, estensioni...
- **Configurazione**: quali configurazioni necessita la nostra applicazione? Variabili d'ambiente, file di configurazione...
- **Servizi**: quali servizi necessita la nostra applicazione? Database, cache, mail...

---

# Installare il software necessario

Non sono tutti necessari, tra di loro sono intercambiabili e i container prodotti sono al 100% compatibili.

- Docker
- <span v-mark.red.underline="{ at: 1 }">Podman</span>
- NerdCTL

<div class="grid grid-cols-3 gap-10 mx-10 items-center">
  <img src="./assets/docker-logo-blue.svg" />
  <img v-mark.red.circle="{ at: 1 }" src="./assets/podman-logo-full-vert.png" />
  <img class="dark:bg-white" src="./assets/nerdctl.svg" />
</div>

<v-click>

Nel nostro caso, useremo `podman`, per mantenere una continuità con NethServer 8.

</v-click>

---
layout: section
---

# Ready, set, go!

---

# Da dove partiamo?

Andremo step by step, creando un container per un'applicazione web in PHP.

Nel nostro caso, simuleremo anche la situazione che l'app necessiti di un database MySQL.

Partiamo da ubuntu, installiamo PHP e MySQL, e creiamo un'applicazione web?

... oppure esiste un container che già fa questo lavoro?

Vediamo cosa sono i registri di container.

<!-- PHP è solamente stato scelto perché ancora è così tanto usato che è uno scenario molto reale. -->

---

# I registri di container

Cosa sono, e come si usano?

Pensate i registri di container come dei repository di pacchetti, ma per i container.

Ne esistono di pubblici e privati, e sono il punto di partenza per la creazione di un container.

Alcuni esempi:

- **Docker Hub**: il più famoso, con milioni di immagini <mdi-docker />
- **Quay.io**: un altro famoso, mantenuto da Red Hat <mdi-redhat />
- **GitHub Container Registry**: il registro di container di GitHub <mdi-github />
- **GitLab Container Registry**: il registro di container di GitLab <mdi-gitlab />
- E molti altri...

<!-- Far notare che è possible fare mix and match, senza alcun problema. -->

---

# Alla ricerca di un container

Per il nostro esempio, andremo a cercare lo specifico container di `php`.

Accediamo a [Docker Hub](https://hub.docker.com/), e cerchiamo `php`.

<img src="./assets/docker_hub_php.png">

---

# Il container `php`

Proviamo a vedere cosa c'è all'interno del container `php:8-apache`.

```bash 
podman run --rm -it php:8-apache bash
```

- `podman run`: crea e avvia un nuovo container
- `--rm`: rimuove il container al termine dell'esecuzione
- `-it`: apre una sessione interattiva
- `php:8-apache`: l'immagine da cui creare il container
- `bash`: il comando da eseguire all'interno del container

<br />
```bash
root@container_id:/# php -v
```

```
PHP 8.3.12 (cli) (built: Oct 17 2024 02:21:29) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.3.12, Copyright (c) Zend Technologies
```

---
layout: image-right
image: /iceberg.jpg
---

# Come si riusa un container?

Bello `php`, ma mancano le mie cose!

Useremo l'immagine `php` come base, e aggiungeremo il nostro software e le nostre dipendenze

Nella prossima slide introdurremo il concetto di `Dockerfile` o `Containerfile`, che ci permetterà di creare un container personalizzato partendo da un'immagine esistente

Noi oggi scalfiremo giusto la superficie dell'iceberg

---

# Riusiamo il container `php`

Vediamo nel dettaglio il file di build che sarà dentro il nostro progetto.

```dockerfile {*|1|2|3-5,8-9|6-7}{lines:true}
FROM php:8-apache
WORKDIR /var/www/html
RUN apt-get update \
  && apt-get install -y libzip-dev \
  && docker-php-ext-install pdo pdo_mysql zip
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
COPY . .
RUN chown -R www-data:www-data /var/www/html/storage \
  && composer install --no-dev
```

<v-clicks at="1">

`FROM` istruisce il builder di usare l'immagine a seguire come base di partenza.

`WORKDIR` imposta la directory di lavoro all'interno del container

`RUN` esegue un comando all'interno del container

`COPY` invece, copia un file o una directory da una sorgente a una destinazione (la sorgente può essere anche un altro container!)

</v-clicks>

---

# Eseguire la build

Come si esegue il build del container?

Come abbiamo visto, il file di build serve come automazione per la creazione del container, non ci sono operazioni strane da eseguire, rimane tutto come lo faremo mano a mano noi.

A questo punto, possiamo eseguire la build del container. 

```bash
podman build --tag ghcr.io/nethesis/meeting-2024-app:latest .
```

- `podman build`: crea un'immagine
- `--tag`: assegna un tag all'immagine creata, il formato è il seguente:
  - `registro`: dove noi vogliamo pubblicare l'immagine
  - `nome`: il nome dell'immagine
  - `tag`: la versione dell'immagine
- `.`: il percorso di contesto per la build, ovvero la cartella dove mettiamo il progetto

E abbiamo creato il nostro container! <mdi-party-popper />

---

# E il DB?

Non dobbiamo fare lo stesso per il database, vero?

Fortunatamente no, esistono già molte immagini database pronte per l'uso.

Nel nostro caso, useremo `mysql:8`.

```bash
podman run --rm -i -t \
  -e MYSQL_RANDOM_ROOT_PASSWORD=true \
  -e MYSQL_DATABASE=laravel \
  -e MYSQL_USER=laravel \
  -e MYSQL_PASSWORD=laravel \
  -v database_data:/var/lib/mysql \
  -p 3306:3306 \
  mysql:8.4
```

Abbiamo delle variabili d'ambiente per configurare il database, e un volume per mantenere i dati persistenti.

Naturalmente dobbiamo esporre una porta per poter accedere al database.

---
src: ./credits.md
---
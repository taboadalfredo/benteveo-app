# benteveo-app

### Contexto (System Context Diagram)

![context](images/contexto.png)

La api se ocupa de recibir las peticiones de los usuarios para crear un mensaje de micro-bloogin(tweet), seguir usuarios y consultar los mensajes publicados por otros usuarios. 
Ademas, orquesta la persistencia del mensaje y de propagarlo entre todas las instancias de modo tal de que este disponible en los timelines que necesiten leerlos. 

### Contenedores (Container Diagram)

![containers](images/contenedores.png)

app-container es el contenedor administra las peticiones.
cache guarda temporalmente los tweets mas recientes para consultas rapidas.
base de datos para la persistencia "en frio" de los tweets.

### Diagrama de Componentes (Component Diagram)

![components](images/componentes.png)

La aplicación utilizará un load balancer para separar el tráfico entre escritura y lectura. La creación de nuevos tweets o comenzar a seguir a una persona irán a una instancia maestra que se ocupará de persistir la información en una base de datos maestra y escribir la novedad relacionada en una cola de SNS. Esta cola se ocupará de distribuir las novedades entre las distintas colas SQS de cada instancia esclava.
Las instancias esclavas procesaran las novedades de la cola SQS y actualizarán la información en la memoria caché y en la base de datos esclava.

La lectura del timeline se realizará contra la caché, donde se tendrán los últimos tweets de todos los usuarios de manera de poder obtener las últimas novedades en general de una manera mas rapida. La caché tendrá una lógica de Least Recently Used(LRU) para mantener los registros más usados.

**Opcional: Tratar de hacer una carga preventiva. Es decir que si al timeline lo devuelvo paginado y me consultan la pagina N, dejar corriendo un proceso que cargue en la caché la pagina N+1.**

# benteveo-app

### Contexto (System Context Diagram)

![context](images/contexto.png)

La api se ocupa de recibir las peticiones de los usuarios para crear un mensaje de micro-bloogin(tweet), seguir usuarios y consultar los mensajes publicados por otros usuarios. 
Ademas, orquesta la persistencia del mensaje y de propagarlo entre todas las instancias de modo tal de que este disponible en los timelines que necesiten leerlos. 


# SalinasChallenge

Banco Azteca, Institución de Banca Múltiple
Test para desarrolladores de iOS
El objetivo del test es crear una aplicación que permita visualizar un listado de películas, donde el cliente pueda leer una breve descripción de las que sean de su interés, así como de permitir seleccionar aquellas que sean de sus favoritas.
Requisitos
Desarrollo de la aplicación.
La app tiene un tab bar con 2 opciones: • TV Shows
• Favoritos
Pantalla de shows de televisión (P01)
En esta pantalla el usuario puede visualizar un listado de shows de televisión existentes. Como usuario debo ser capaz de marcar un programa como favorito o quitarlo de los mismos.
Criterios de aceptación
• Esta es la pantalla principal de la aplicación
• Cuando cargue esta vista, se debe mostrar un listado de programas de televisión
utilizando la API de TV Maze. (http://api.tvmaze.com/)
• El listado debe contener la portada del show (JSON key: image.medium) y el título
del mismo (JSON key: name)
• Cada fila debe tener una acción para marcar el show como favorito o eliminarlo del
listado de favoritos
• La acción de Borrar de favoritos debe estar en color rojo y con el texto en color
blanco que diga “Delete”
• La acción de agregar como favoritos debe estar en color verde y con el texto en color
blanco que diga “Favorite”
• Cuando el usuario dé clic en borrar debe mostrar una alerta para confirmar o
cancelar la eliminación del catálogo de favoritos
• En cada interacción con estos botones, se debe actualizar el almacenamiento local
• Ante cualquier fallo en la aplicación, se debe mostrar un mensaje de error con
o Título “Oops, algo salió mal!”
o Texto de la alerta cuando exista un error al marcarlo o eliminarlo como
favorito debe decir: “Hubo un problema al guardar/borrar este show de TV. ¿Quieres intentar nuevamente?
• La aplicación debe ser desarrollada en Swift 4.2 ó superior
• La aplicación debe ser compatible para dispositivos con iOS 10 ó superior.
• La aplicación debe correr únicamente en teléfonos.
• Persistencia con cualquier tipo de almacenamiento local
• Tener bien definida una arquitectura de aplicación
• Pruebas unitarias
 
 Banco Azteca, Institución de Banca Múltiple
o Texto de la alerta cuando exista un error de conexión: “Ocurrió un error al consultar el servicio. ¿Quieres intentar nuevamente?
• Al seleccionar un show de televisión se debe mostrar la pantalla del detalle de show (P03)
• La pantalla deberá tener un look & feel lo más parecido al siguiente.
   
 Banco Azteca, Institución de Banca Múltiple
Pantalla de favoritos (P02)
En esta pantalla el usuario podrá visualizar los shows de televisión que marcó previamente como favoritos.
Criterios de aceptación
• Mostrará todas los shows que hayan sido marcados como favoritos
• Cada fila del listado deberá tener una acción para eliminarla del listado de favoritos
• Se debe mostrar una alerta de confirmación cuando el usuario quiera eliminar una
fila
• Cuando se confirme la eliminación se deberá actualizar el almacenamiento local y
actualizar el listado de favoritos
• Cuando el cliente dé clic sobre una fila, se deberá mostrar la pantalla del detalle del
show (P03).
Pantalla de detalle de show (P03)
En esta pantalla el usuario podrá ver el detalle de un show de TV, así como también marcarlo o quitarlo del listado de favoritos.
Criterios de aceptación
• Esta pantalla deberá mostrar:
o La imagen de la portada del show (JSON key: image.original)
o Resumen del show (JSON key: summary)
o Un botón para abrir la página del show en IMDb (JSON key: externals.imdb) o Cualquier otra información que consideres relevante
  
 Banco Azteca, Institución de Banca Múltiple
• El diseño de la pantalla corre por tu cuenta
• El título del navigation controller deberá ser el nombre del show.
• Cuando no exista un id de IMDB, el botón con el link deberá ocultarse
• Se deberá mostrar un botón en la parte derecha del navigation controller para
marcar o quitar el show del listado de favoritos
o Cuando el show esté marcado previamente como favorito, el botón deberá
tener la leyenda “Delete”
o Cuando no esté marcado como favorito, el botón deberá tener la leyenda
“Favorite”
o Puedes customizar este botón tanto como quieras
Notas
• Esta práctica deberá entregarse en un plazo no mayor a 3 días.
• Trata de usar las librerías externas en lo más mínimo.
• El proyecto debe compilar con la menor cantidad de warnings y ejecutarse de
manera correcta
• Cualquier punto desarrollado de manera adicional (como animaciones, otras
pantallas, etc.) será considerado para la evaluación.
• Debes proporcionar un archivo COMMENTS.txt junto con tu proyecto que
contenga la explicación:
o Explicar la arquitectura que utilizaste en tu proyecto y la razón por la que
decidiste utilizarla
o Lista de las librerías externas que utilizaste, explicándo qué hacen y la razón
por la que la elegiste
o Qué parte(s) de tu código pueden ser mejoradas si tuvieras más tiempo
o Cuáles fueron los mayores problemas que encontraste en el desarrollo de
la práctica y cómo los resolviste?
o Si alguno de los puntos solicitados no los concluiste, menciona por qué. Si
fuera por cuestión de tiempo, trata de mencionar qué estrategia llevarías a cabo para desarrollarlo

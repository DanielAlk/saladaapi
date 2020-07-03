class DataController < ApplicationController
	def marquesine
		render json: Product.where(special: Product.specials[:towering]).limit(4).order("RAND()")
	end

  def shop
  	render json: { locations: Shop.locations, conditions: Shop.conditions, gallery_names: [ 'Arcoíris', 'Factory', 'Colores', 'El Imperio', 'María Concepción', 'Quivincha', 'Valencia', 'Gale', 'Felipe', 'El Trébol', 'La Unión', 'JR', 'Trinidad', 'El Árbol', 'Angie', 'M.F.G. Factory S.A.', 'Coty', '27 de Mayo', 'Milagros y Janina', 'Amalia', 'Tilcarita', 'San Jorge', 'JJ Valle 3062' ] }
  end

  def profile_buttons
  	if false
	  	render json: {
	  		buttons: [
		  		{
		  			id: 0,
		  			text: 'Anunciar en SaladaApp',
		  			style: 'button-positive',
		  			external: true,
		  			href: 'http://google.com'
		  		},
		  		{
		  			id: 1,
		  			text: 'Solicitar baja',
		  			style: '',
		  			external: true,
		  			href: 'http://google.com.ar'
		  		},
		  		{
		  			id: 2,
		  			text: 'Otro',
		  			style: 'button-positive',
		  			internal: true,
		  			state: 'app.shop',
		  			params: { id: 1 }
		  		}
		  	]
		  }
		else
			render json: {
				buttons: []
			}
		end
  end

  def texts
  	if user_signed_in?
  		if current_user.client?
  			if current_user.free?
  				greeting = 'Ya puedes empezar a utilizar SaladaApp. Recordá que los usuarios premium tienen beneficios especiales, considerá abonar la suscripción para empezar a aprovechar los beneficios.'
  			elsif current_user.premium?
  				greeting = 'La cuenta permanecerá abierta 96 por horas, lapso durante el cual se deberá abonar el plan seleccionado en efectivo, un cobrador se acercará al puesto por usted designado a retirar el pago.<br><br>De no realizarse el mismo pasadas dichas 96 horas, la cuenta será dada de baja.'
  			end
			elsif current_user.seller?
  			if current_user.free?
  				greeting = 'Ya puedes empezar a utilizar SaladaApp. Recordá que los usuarios premium tienen beneficios especiales, considerá abonar la suscripción para empezar a aprovechar los beneficios.'
  			elsif current_user.premium?
  				greeting = 'La cuenta permanecerá abierta 96 por horas, lapso durante el cual se deberá abonar el plan seleccionado en efectivo, un cobrador se acercará al puesto por usted designado a retirar el pago.<br><br>De no realizarse el mismo pasadas dichas 96 horas, la cuenta será dada de baja.'
  			end
			elsif current_user.provider?
  			if current_user.free?
  				greeting = 'Ya puedes empezar a utilizar SaladaApp. Recordá que los usuarios premium tienen beneficios especiales, considerá abonar la suscripción para empezar a aprovechar los beneficios.'
  			elsif current_user.premium?
  				greeting = 'La cuenta permanecerá abierta 96 por horas, lapso durante el cual se deberá abonar el plan seleccionado en efectivo, un cobrador se acercará al puesto por usted designado a retirar el pago.<br><br>De no realizarse el mismo pasadas dichas 96 horas, la cuenta será dada de baja.'
  			end
			end
  	else
  		greeting = '';
  	end
  	render json: {
  		greeting: greeting
  	}
  end

  def terms_and_conditions
  	appConfig = AppConfig.find_by(sid: 'terms_and_conditions')
  	render json: {
  		terms_and_conditions: appConfig.content
  	}
  end

  def privacy_policy
  	render json: {
  		link_free_privacy_policy: 'https://www.freeprivacypolicy.com/privacy/view/ae90dccc4414efc1dd7f51b09f19c4e7',
  		privacy_policy: '
  			<h1>Política de privacidad</h1>
  			<p>Fecha efectiva: September 26, 2018</p>
  			<p>SaladaApp ("nosotros", "a nosotros", "nuestro") opera el sitio web y la aplicación móvil SaladaApp (en adelante, el "Servicio").</p>
  			<p>Esta página le informa de nuestras políticas en materia de recopilación, uso y divulgación de datos personales cuando utiliza nuestro Servicio y de las opciones de las que dispone en relación con esos datos.</p>
  			<p>Utilizamos sus datos para prestarle el Servicio y mejorarlo. Al utilizar el Servicio, usted acepta la recopilación y el uso de información de conformidad con esta política. A menos que esta Política de privacidad defina lo contrario, los términos utilizados en ella tienen los mismos significados que nuestros Términos y Condiciones.</p>
  			<h2>Definiciones</h2>
  			<ul>
  				<li>
  					<p><strong>Servicio</strong></p>
  					<p>Servicio significa el sitio web  y la aplicación móvil SaladaApp operados por SaladaApp</p>
  				</li>
  				<li>
  					<p><strong>Datos personales</strong></p>
  					<p>Datos personales significa los datos sobre una persona física viva que puede ser identificada a partir de esos datos (o con esos datos y otra información de la que dispongamos o probablemente podamos disponer).</p>
  				</li>
  				<li>
  					<p><strong>Datos de uso</strong></p>
  					<p>Datos de uso son los datos recopilados automáticamente, generados por el uso del Servicio o por la propia infraestructura del Servicio (por ejemplo, la duración de la visita a una página).</p>
  				</li>
  				<li>
  					<p><strong>Cookies</strong></p>
  					<p>Las cookies son pequeños archivos ialmacenados en su dispositivo (ordenador o dispositivo móvil).</p>
  				</li>
  			</ul>
  			<h2>Recopilación y uso de la información</h2>
  			<p>Recopilamos diferentes tipos de información con diversas finalidades para prestarle el Servicio y mejorarlo.</p>
  			<h3>Tipos de datos recopilados</h3>
  			<h4>Datos personales</h4>
  			<p>Cuando utilice nuestro Servicio, es posible que le pidamos que nos proporcione determinada información personalmente identificable que podrá ser utilizada para contactar con usted o para identificarle ("Datos personales"). La información personalmente identificable puede incluir, entre otras, la siguiente:</p>
  			<ul>
  				<li>Dirección de e-mail</li>
  				<li>Nombre y apellidos</li>
  				<li>Número de teléfono</li>
  				<li>Dirección, localidad, provincia, código postal, ciudad</li>
  				<li>Cookies y datos de uso</li>
  			</ul>
  			<h4>Datos de uso</h4>
  			<p>También podemos recopilar información que envía su dispositivo siempre que visita nuestro Servicio o cuando usted accede al Servicio a través de un dispositivo móvil ("Datos de uso").</p>
  			<p>Estos Datos de uso pueden incluir información como la dirección del protocolo de Internet de su ordenador (por ejemplo, dirección IP), tipo de navegador, versión del navegador, las páginas que visita de nuestro Servicio, la hora y la fecha de su visita, el tiempo que pasa en esas páginas, identificadores exclusivos de dispositivos y otros datos de diagnóstico.</p>
  			<p>Cuando accede al Servicio econ un dispositivo móvil, estos Datos de uso pueden incluir información como el tipo de dispositivo móvil que utiliza, el identificador exclusivo de su dispositivo móvil, la dirección de IP de su dispositivo móvil, el sistema operativo de su dispositivo móvil, el tipo de navegador de Internet que utiliza su dispositivo móvil, identificadores exclusivos de dispositivos y otros datos de diagnóstico.</p>
  			<h4>Datos de cookies y seguimiento</h4>
  			<p>Utilizamos cookies y tecnologías de seguimiento similares para rastrear la actividad de nuestro Servicio y mantener determinada información.</p>
  			<p>Las cookies son archivos con una pequeña cantidad de datos que pueden incluir un identificador exclusivo anónimo. Las cookies son enviadas a su navegador desde un sitio web y se almacenan en su dispositivo. Otras tecnologías de seguimiento también utilizadas son balizas, etiquetas y scripts para recopilar y rastrear la información, así como para mejorar y analizar nuestro Servicio.</p>
  			<p>Usted puede ordenar a su navegador que rechace todas las cookies o que le avise cuando se envía una cookie. Sin embargo, si no acepta cookies, es posible que no pueda utilizar algunas partes de nuestro Servicio.</p>
  			<p>Ejemplos de Cookies que utilizamos:</p>
  			<ul>
  				<li><strong>Cookies de sesión.</strong> Utilizamos Cookies de sesión para operar nuestro Servicio.</li>
  				<li><strong>Cookies de preferencia.</strong> Utilizamos Cookies de preferencia para recordar sus preferencias y diversos ajustes.</li>
  				<li><strong>Cookies de seguridad.</strong> Utilizamos Cookies de seguridad para fines de seguridad.</li>
  			</ul>
  			<h2>Uso de datos</h2> 
  			<p>SaladaApp utiliza los datos recopilados con diversas finalidades:</p>
  			<ul>
  				<li>Suministrar y mantener nuestro Servicio</li>
  				<li>Notificarle cambios en nuestro Servicio</li>
  				<li>Permitirle participar en funciones interactivas de nuestro Servicio cuando decida hacerlo</li>
  				<li>Prestar asistencia al cliente</li>
  				<li>Recopilar análisis o información valiosa que nos permitan mejorar nuestro Servicio</li>
  				<li>Controlar el uso de nuestro Servicio</li>
  				<li>Detectar, evitar y abordar problemas técnicos</li>
  			</ul>
  			<h2>Transferencia de datos</h2>
  			<p>Su información, incluyendo Datos personales, puede ser transferida a —y mantenida en— ordenadores localizados fuera de su estado, provincia, país u otra jurisdicción gubernamental donde las leyes de protección de datos pueden diferir de las de su jurisdicción.</p>
  			<p>Si usted se encuentra fuera de Argentina y decide facilitarnos información, tenga en cuenta que nosotros transferimos los datos, incluyendo Datos personales, a Argentina y que los tratamos allí.</p>
  			<p>Su aceptación de esta Política de privacidad seguida de su envío de esta información representa que está de acuerdo con dicha transferencia.</p>
  			<p>SaladaApp emprenderá todas las medidas razonables necesarias para garantizar que sus datos sean tratados de forma segura y de conformidad con esta Política de privacidad y no se realizará ninguna transferencia de sus Datos personales a una organización o país, salvo que existan unos controles adecuados establecidos incluyendo la seguridad de sus datos y otra información personal.</p>
  			<h2>Divulgación de datos</h2>
  			<h3>Requisitos legales</h3>
  			<p>SaladaApp puede divulgar sus Datos personales de buena fe cuando considere que esta acción es necesaria para lo siguiente:</p>
  			<ul>
  				<li>Cumplir una obligación legal</li>
  				<li>Proteger y defender los derechos o bienes de SaladaApp</li>
  				<li>Prevenir o investigar posibles infracciones en relación con el Servicio</li>
  				<li>Proteger la seguridad personal de usuarios del Servicio o del público</li>
  				<li>Protegerse frente a consecuencias legales</li>
  			</ul>
  			<h2>Seguridad de los datos</h2>
  			<p>La seguridad de sus datos es importante para nosotros, pero recuerde que ningún método de transmisión por Internet o método de almacenamiento electrónico resulta 100% seguro. A pesar de que nos esforzamos por utilizar medios comercialmente aceptables para proteger sus Datos personales, no podemos garantizar su seguridad absoluta.</p>
  			<h2>Proveedores de servicios</h2>
  			<p>Podemos contratar a personas físicas y jurídicas terceras para facilitar nuestro Servicio ("Proveedores de servicios"), para que presten el Servicio en nuestro nombre, para que suministren servicios relacionados con el Servicio o para que nos ayuden a analizar cómo se utiliza nuestro Servicio.</p>
  			<p>Estos terceros tienen acceso a sus Datos personales únicamente para realizar estas tareas en nuestro nombre y están obligados a no divulgarlos ni utilizarlos con ningún otro fin.</p>
  			<h2>Enlaces a otros sitios</h2>
  			<p>Nuestro Servicio puede contener enlaces a otros sitios no operados por nosotros. Si hace clic en el enlace de un tercero, será dirigido al sitio de ese tercero. Le recomendamos encarecidamente que revise la Política de privacidad de todos los sitios que visite.</p>
  			<p>No tenemos ningún control ni asumimos responsabilidad alguna con respecto al contenido, las políticas o prácticas de privacidad de sitios o servicios de terceros.</p>
  			<h2>Privacidad del menor</h2>
  			<p>Nuestro servicio no está dirigido a ningún menor de 18 años (en adelante, "Menor").</p>
  			<p>No recopilamos de forma consciente información personalmente identificable de menores de 18 años. Si es usted un padre/madre o tutor y tiene conocimiento de que su hijo nos ha facilitado Datos personales, contacte con nosotros. Si tenemos conocimiento de que hemos recopilado Datos personales de menores sin verificación del consentimiento parental, tomamos medidas para eliminar esa información de nuestros servidores.</p>
  			<h2>Cambios en esta Política de privacidad</h2>
  			<p>Podemos actualizar nuestra Política de privacidad periódicamente. Le notificaremos cualquier cambio publicando la nueva Política de privacidad en esta página.</p>
  			<p>Le informaremos a través del e-mail y/o de un aviso destacado sobre nuestro Servicio antes de que el cambio entre en vigor y actualizaremos la «fecha efectiva» en la parte superior de esta Política de privacidad.</p>
  			<p>Le recomendamos que revise esta Política de privacidad periódicamente para comprobar si se ha introducido algún cambio. Los cambios en esta Política de privacidad entran en vigor cuando se publican en esta página.</p>
  			<h2>Contacte con nosotros</h2>
  			<p>Si tiene alguna pregunta sobre esta Política de privacidad, contacte con nosotros: </p>
  			<ul>
  				<li>Por e-mail: appsalada@gmail.com</li>
  			</ul>
  		'
  	}
  end
end

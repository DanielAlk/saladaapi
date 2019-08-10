class DataController < ApplicationController
	def marquesine
		render json: Product.where(special: Product.specials[:towering]).limit(4).order("RAND()")
	end

  def shop
  	render json: { locations: Shop.locations, conditions: Shop.conditions, gallery_names: [ 'Factory', 'Colores', 'Quinincha', 'El Imperio', 'María Concepción', 'Quivincha', 'Valencia', 'Gale', 'Felipe', 'El Trébol', 'La Unión', 'JR', 'Trinidad', 'El Árbol', 'Angie', 'M.F.G. Factory S.A.', 'Coty', '27 de Mayo', 'Milagros y Janina', 'Amalia', 'Tilcarita', 'San Jorge' ] }
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
			end
  	else
  		greeting = '';
  	end
  	render json: {
  		greeting: greeting
  	}
  end

  def terms_and_conditions
  	render json: {
  		terms_and_conditions: '
  			<h1>Términos y condiciones de uso del Sitio</h1>
				<h2>Versión vigente 24/9/2018</h2>
				<p>Este contrato describe los términos y condiciones generales (los "Términos y Condiciones Generales") aplicables al uso de los servicios ofrecidos por el sitio “SALADA APP”. Cualquier persona (en adelante "Usuario" o en plural "Usuarios") que desee acceder y/o usar el sitio o los Servicios podrá hacerlo sujetándose a los Términos y Condiciones Generales respectivos, junto con todas las demás políticas y principios que rigen para Salada App y que son incorporados al presente.</p>
				<p>CUALQUIER PERSONA QUE NO ACEPTE ESTOS TÉRMINOS Y CONDICIONES GENERALES, LOS CUALES TIENEN UN CARÁCTER OBLIGATORIO Y VINCULANTE, DEBERÁ ABSTENERSE DE UTILIZAR EL SITIO Y/O LOS SERVICIOS.</p>
				<p>El Usuario debe leer, entender y aceptar todas las condiciones establecidas en los Términos y Condiciones Generales y en las Políticas de Privacidad así como en los demás documentos incorporados a los mismos por referencia, previo a su registración como Usuario de Salada App, optando de forma expresa por recibir los mismos y toda otra información por medios digitales.</p>
				<h3>01 - Capacidad</h3>
				<p>Los Servicios sólo están disponibles para personas que tengan capacidad legal para contratar. No podrán utilizar los servicios las personas que no tengan esa capacidad, los menores de edad o Usuarios de Salada App hayan sido suspendidos temporalmente o inhabilitados definitivamente. Si estás registrando un Usuario como Empresa, debes tener capacidad para contratar a nombre de tal entidad y de obligar a la misma en los términos de este Acuerdo.</p>
				<h3>02 - Registración</h3>
				<p>Es obligatorio completar el formulario de registración en todos sus campos con datos válidos para poder utilizar los servicios que brinda Salada App. Los usuarios pueden catalogarse como “usuarios visitantes”; “usuarios comerciantes” y/o “usuarios anunciantes”. El futuro Usuario deberá completar el Formulario de acuerdo a la categoría al que pertenezca,  con su información personal de manera exacta, precisa y verdadera ("Datos Personales") y asume el compromiso de actualizar los Datos Personales conforme resulte necesario. El Usuario presta expresa conformidad con que Salada App utilice diversos medios para identificar sus datos personales, asumiendo el Usuario la obligación de revisarlos y mantenerlos actualizados. Salada App NO se responsabiliza por la certeza de los Datos Personales de los Usuarios. Los Usuarios garantizan y responden, en cualquier caso, de la veracidad, exactitud, vigencia y autenticidad de sus Datos Personales.</p>
				<p>A su exclusiva discreción, Salada App podrá requerir una registración adicional a los Usuarios que operen dentro del sitio (“usuarios comerciantes” y/o “usuarios anunciantes”, como requisito para que dichos Usuarios accedan a paquetes especiales de publicaciones. En estos casos, una vez efectuada la registración adicional, las publicaciones que se realicen, sólo se publicarán en “el sitio” a través de alguno de dichos paquetes o bajo las modalidades que Salada App habilite para este tipo de Usuarios. Salada App se reserva el derecho de solicitar algún comprobante y/o dato adicional a efectos de corroborar los Datos Personales, así como de suspender temporal o definitivamente a aquellos Usuarios cuyos datos no hayan podido ser confirmados. En estos casos de inhabilitación, se dará de baja todos los artículos publicados, así como las ofertas realizadas, sin que ello genere algún derecho a resarcimiento.</p>
				<p>El Usuario accederá a su cuenta personal ("Cuenta") mediante el ingreso de su Apodo y clave de seguridad personal elegida ("Clave de Seguridad"). El Usuario se obliga a mantener la confidencialidad de su Clave de Seguridad.</p>
				<p>La Cuenta es personal, única e intransferible, y está prohibido que un mismo Usuario registre o posea más de una Cuenta. En caso que Salada App  detecte distintas Cuentas que contengan datos coincidentes o relacionados, podrá cancelar, suspender o inhabilitarlas.</p>
				<p>El Usuario será responsable por todas las publicaciones efectuadas en su Cuenta, pues el acceso a la misma está restringido al ingreso y uso de su Clave de Seguridad, de conocimiento exclusivo del Usuario. El Usuario se compromete a notificar a Salada App  en forma inmediata y por medio idóneo y fehaciente, cualquier uso no autorizado de su Cuenta, así como el ingreso por terceros no autorizados a la misma. Se aclara que está prohibida la venta, cesión o transferencia de la Cuenta (incluyendo la reputación y calificaciones) bajo ningún título.</p>
				<p>Salada App se reserva el derecho de rechazar cualquier solicitud de registración o de cancelar una registración previamente aceptada, sin que esté obligado a comunicar o exponer las razones de su decisión y sin que ello genere algún derecho a indemnización o resarcimiento.</p>
				<h3>03 - Modificaciones del Acuerdo</h3>
				<p>Salada App podrá modificar los Términos y Condiciones Generales en cualquier momento haciendo públicos en el Sitio los términos modificados. Todos los términos modificados entrarán en vigor a los 10 (diez) días de su publicación. Dichas modificaciones serán comunicadas por Salada App  a los usuarios que en la Configuración de su Cuenta de (el sitio) hayan indicado que desean recibir notificaciones de los cambios en estos Términos y Condiciones. Todo usuario que no esté de acuerdo con las modificaciones efectuadas por Salada App  podrá solicitar la baja de la cuenta.</p>
				<p>El uso del sitio y/o sus servicios implica la aceptación de estos Términos y Condiciones generales de uso de Salada App.</p>
				<h3>04 - Inclusión de imágenes y fotografías</h3>
				<p>El usuario puede incluir imágenes y fotografías del producto publicado siempre que las mismas se correspondan con el artículo, salvo que se trate de bienes o productos que por su naturaleza no permiten esa correspondencia.</p>
				<p>Salada App podrá impedir la publicación de la fotografía, e incluso del producto, si interpretara, a su exclusivo criterio, que la imagen no cumple con los presentes Términos y Condiciones. Las imágenes y fotografías de artículos publicados deberán cumplir con algunos requisitos adicionales como condición para ser expuestas en la Página Principal del Sitio Web.</p>
				<h3>05.-  Artículos Prohibidos</h3>
				<p>Sólo podrán ser ingresados en las listas de bienes ofrecido, aquellos cuya venta no se encuentre tácita o expresamente prohibida en los Términos y Condiciones Generales y demás políticas de Salada App o por la ley vigente. Para obtener mayor información sobre artículos o servicios prohibidos, se pueden consultar nuestras Políticas de Artículos Prohibidos de Salada App.</p>
				<h3>06.-  Protección de Propiedad Intelectual</h3>
				<p>Salada App no será responsable por aquellos artículos publicados que infrinjan derechos de propiedad intelectual e industrial y cualesquiera otros de terceros. Quienes sean titulares de derechos podrán identificar y solicitar la remoción de aquellos artículos que a su criterio infrinjan o violen sus derechos. En caso que Salada App sospeche que se está cometiendo o se ha cometido una actividad ilícita o infractora de derechos de propiedad intelectual o industrial, Salada App se reserva el derecho de adoptar todas las medidas que entienda adecuadas, lo que puede incluir dar acceso limitado a los participantes del sitio.</p>
				<h3>07.- Privacidad de la Información</h3>
				<p>Para utilizar los Servicios ofrecidos por Salada App, los Usuarios deberán facilitar determinados datos de carácter personal. Su información personal se procesa y almacena en servidores o medios magnéticos que mantienen altos estándares de seguridad y protección tanto física como tecnológica. Para mayor información sobre la privacidad de los Datos Personales y casos en los que será revelada la información personal, se pueden consultar nuestras Políticas de Privacidad.</p>
				<h3>08 -  Responsabilidad</h3>
				<p>Salada App sólo pone a disposición de los Usuarios un espacio virtual que les permite ponerse en comunicación mediante Internet para encontrar una forma de publicitar bienes. Salada App no es la propietaria de los artículos publicados, no tiene posesión de ellos ni los ofrece en venta. Salada App no interviene en el perfeccionamiento de las operaciones que eventualmente se realice  entre los Usuarios ni en las condiciones por ellos estipuladas para las mismas, por ello no será responsable respecto de la existencia, calidad, cantidad, estado, integridad o legitimidad de los bienes ofrecidos, y/o eventualmente adquiridos o enajenados por los Usuarios, así como de la capacidad para contratar de los Usuarios o de la veracidad de los Datos Personales por ellos ingresados. Cada Usuario conoce y acepta ser el exclusivo responsable por los artículos que publica.</p>
				<p>Debido a que Salada App no tiene ninguna participación durante todo el tiempo en que el artículo se publica, no será responsable por el efectivo cumplimiento de las obligaciones asumidas por los Usuarios en el perfeccionamiento cualquier operación. El Usuario conoce y acepta que al realizar operaciones con otros Usuarios o terceros lo hace bajo su propio riesgo. En ningún caso Salada App será responsable por lucro cesante, o por cualquier otro daño y/o perjuicio que haya podido sufrir el Usuario, debido a las publicaciones realizadas o no realizadas por artículos publicados a través de Salada App.</p>
				<p>Salada App recomienda actuar con prudencia y sentido común al momento de realizar operaciones con otros Usuarios. El Usuario debe tener presente, además, los riesgos de contratar con menores o con personas que se valgan de una identidad falsa. Salada App NO será responsable por la realización de ofertas y/u operaciones con otros Usuarios basadas en la confianza depositada en el sistema o los Servicios brindados por Salada App.</p>
				<p>En caso que uno o más Usuarios o algún tercero inicien cualquier tipo de reclamo o acciones legales contra otro u otros Usuarios, todos y cada uno de los Usuarios involucrados en dichos reclamos o acciones eximen de toda responsabilidad a Salada App,  sus directores, gerentes, empleados, agentes, operarios, representantes y apoderados.</p>
				<h3>09 - Alcance de los servicios de Salada App</h3>
				<p>Este acuerdo no crea ningún contrato de sociedad, de mandato, de franquicia, o relación laboral entre Salada App y el usuario. El usuario reconoce y acepta que Salada App no es parte en ninguna operación, ni tiene control alguno sobre la calidad, seguridad o legalidad de los artículos anunciados, la veracidad o exactitud de los anuncios, la capacidad de los Usuarios para vender o comprar artículos. Salada App no puede asegurar que un usuario completará cualquier operación ni podrá verificar la identidad o datos personales ingresados por los usuarios. Salada App  no garantiza la veracidad de la publicidad de terceros que aparezca en el sitio y no será responsable por la correspondencia o contratos que el usuario celebre con dichos terceros o con otros usuarios.</p>
				<h3>10 - Fallas en el sistema</h3>
				<p>Salada App no se responsabiliza por cualquier daño, perjuicio o pérdida al usuario causados por fallas en el sistema, en el servidor o en Internet. Salada App tampoco será responsable por cualquier virus que pudiera infectar el equipo del usuario como consecuencia del acceso, uso o examen de su sitio web o a raíz de cualquier transferencia de datos, archivos, imágenes, textos, o audio contenidos en el mismo. Los usuarios NO podrán imputarle responsabilidad alguna ni exigir pago por lucro cesante, en virtud de perjuicios resultantes de dificultades técnicas o fallas en los sistemas o en Internet. Salada App no garantiza el acceso y uso continuado o ininterrumpido de su sitio. El sistema puede eventualmente no estar disponible debido a dificultades técnicas o fallas de Internet, o por cualquier otra circunstancia ajena a Salada App; en tales casos se procurará restablecerlo con la mayor celeridad posible sin que por ello pueda imputársele algún tipo de responsabilidad. Salada App no será responsable por ningún error u omisión contenidos en su sitio web.</p>
				<h3>11 - Sistema de reputación</h3>
				<p>Debido a que la verificación de la identidad de los Usuarios en Internet es difícil, la empresa no puede confirmar ni confirma la identidad pretendida de cada Usuario. Por ello el Usuario cuenta con un sistema de reputación de Usuarios que es actualizado periódicamente en base a datos vinculados con su actividad en el sitio y a los comentarios ingresados por los Usuarios según las operaciones que hayan realizado. Los Usuarios habilitados deberán ingresar una calificación informando acerca de la calidad de los bienes publicados; también podrán ingresar un comentario si así lo desean. Este sistema de reputación, además constará de un espacio donde los Usuarios podrán hacer comentarios sobre las calificaciones recibidas y acceder a los mismos. Dichos comentarios serán incluidos bajo exclusiva responsabilidad de los Usuarios que los emitan.</p>
				<p>En virtud que las calificaciones y comentarios que son realizados por los Usuarios, éstos serán incluidos bajo exclusiva responsabilidad de los Usuarios que los emitan. Salada App no tiene obligación de verificar la veracidad o exactitud de los mismos y NO se responsabiliza por los dichos allí vertidos por cualquier Usuario, por las ofertas de compras o ventas que los Usuarios realicen teniéndolos en cuenta o por la confianza depositada en las calificaciones de la contraparte o por cualquier otro comentario expresado dentro del sitio o a través de cualquier otro medio incluido el correo electrónico. Salada App se reserva el derecho de editar y/o eliminar aquellos comentarios que sean considerados inadecuados u ofensivos. Salada App mantiene el derecho de excluir a aquellos Usuarios que sean objeto de comentarios negativos provenientes de fuentes distintas.</p>
				<h3>12 - Enlaces</h3>
				<p>El Sitio puede contener enlaces a otros sitios web, lo cual no indica que sean propiedad u operados por Salada App. En virtud que Salada App no tiene control sobre tales sitios, NO será responsable por los contenidos, materiales, acciones y/o servicios prestados por los mismos, ni por daños o pérdidas ocasionadas por la utilización de los mismos, sean causadas directa o indirectamente. La presencia de enlaces a otros sitios web no implica una sociedad, relación, aprobación, respaldo de Salada App a dichos sitios y sus contenidos.</p>
				<h3>13 - Indemnización</h3>
				<p>El usuario acepta indemnizar y eximir de responsabilidad a Salada App (incluyendo pero no limitando a sus sociedades relacionadas, sus respectivos directores, gerentes, funcionarios, representantes, agentes y empleados) por cualquier reclamo o demanda (incluidos los honorarios razonables de abogados) formulados por cualquier Usuario y/o tercero por cualquier infracción a los Términos y Condiciones de Uso y demás Anexos y Políticas que se entienden incorporadas al presente, y/o cualquier ley y/o derechos de terceros.</p>
				<p>A tal fin, el usuario faculta a Salada App a: i) intervenir y representarlo en dichos reclamos o demandas, pudiendo arribar a acuerdos sin limitación, en su nombre y representación; ii) retener fondos existentes y/o futuros; y/o iii) generar cargos específicos en su facturación.</p>
				<h3>14 - Jurisdicción y Ley Aplicable</h3>
				<p>Este acuerdo estará regido en todos sus puntos por las leyes vigentes en la República Argentina.</p>
				<p>Cualquier controversia derivada del presente acuerdo, su existencia, validez, interpretación, alcance o cumplimiento, será sometida a los tribunales competentes de la Ciudad Autónoma de Buenos Aires.</p>
			'
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

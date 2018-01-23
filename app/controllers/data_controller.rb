class DataController < ApplicationController
	def marquesine
		render json: Product.where(special: Product.specials[:towering]).limit(4).order("RAND()")
	end

  def shop
  	render json: { locations: Shop.locations, conditions: Shop.conditions, gallery_names: [ 'El Imperio', 'El Indio', 'El Dorado' ] }
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
				<h2>Versión vigente 31/7/2017</h2>
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
end

import base64
from django.http import JsonResponse
import json
from django.http import BadHeaderError, JsonResponse
from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status
# Vista para crear un nuevo archivo y almacenar la URL en el modelo
from rest_framework.decorators import api_view
from app_comites.settings import EMAIL_HOST_USER
from .models import *
from .serializer import *
from django.core.mail import EmailMessage, BadHeaderError, get_connection
from django.views.decorators.csrf import csrf_exempt
from supabase import create_client, Client


SUPABASE_URL = 'https://uwrugmhbvoujzbsudrta.supabase.co'  # Tu URL de Supabase
SUPABASE_API_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3cnVnbWhidm91anpic3VkcnRhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI3NTk3NDMsImV4cCI6MjA0ODMzNTc0M30.VfVFQepjX82SlqFZ6XWRXI58dsxBiieevAT8qF2fChc'  # Tu clave de API

supabase: Client = create_client(SUPABASE_URL, SUPABASE_API_KEY)


class ArchivoCitacionViewSet(viewsets.ModelViewSet):
    queryset = ArchivoCitacion.objects.all()
    serializer_class = ArchivoCitacionSerializer

    def create(self, request, *args, **kwargs):
        # Asegurarnos de que los datos de citación y archivo sean enviados correctamente
        citacion_id = request.data.get('citacion')
        file_url = request.data.get('file')
        archivo_url = request.data.get('archivo_url')

        if not citacion_id or not file_url:
            return Response({"error": "Se requiere el ID de citación y el archivo"},
                            status=status.HTTP_400_BAD_REQUEST)

        # Crear una nueva instancia de ArchivoCitacion
        archivo = ArchivoCitacion(
            citacion_id=citacion_id,
            file=file_url,
            archivo_url=archivo_url
        )

        # Guardar el archivo
        archivo.save()

        return Response(ArchivoCitacionSerializer(archivo).data, status=status.HTTP_201_CREATED)




    


# Create your views here.
class UsuarioAprendizViewSet(viewsets.ModelViewSet):
    queryset = UsuarioAprendiz.objects.all()
    serializer_class = UsuarioAprendizSerializer
    
class InstructorViewSet(viewsets.ModelViewSet):
    queryset = Instructor.objects.all()
    serializer_class = InstructorSerializer
    
class AbogadoViewSet(viewsets.ModelViewSet):
    queryset = Abogado.objects.all()
    serializer_class = AbogadoSerializer
    
class CoordinadorViewSet(viewsets.ModelViewSet):
    queryset = Coordinador.objects.all()
    serializer_class = CoordinadorSerializer

class BienestarViewSet(viewsets.ModelViewSet):
    queryset = Bienestar.objects.all()
    serializer_class = BienestarSerializer
   
class RadicacionViewSet(viewsets.ModelViewSet):
    queryset = Radicacion.objects.all()
    serializer_class = RadicacionSerializer
    
class ReglamentoViewSet(viewsets.ModelViewSet):
    queryset = Reglamento.objects.all()
    serializer_class = ReglamentoSerializer
    
class LlamadoAtencionViewSet(viewsets.ModelViewSet):
    queryset = llamadoAtencion.objects.all()
    serializer_class = LlamadoAtencionSerializer
    
class AprendizLlamadoAtencionViewSet(viewsets.ModelViewSet):
    queryset = AprendizLlamadoAtencion.objects.all()
    serializer_class = AprendizLlamadoAtencionSerializer
    
class InstructorLlamadoAtencionViewSet(viewsets.ModelViewSet):
    queryset = InstructorLlamadoAtencion.objects.all()
    serializer_class = InstructorLlamadoAtencionSerializer
    
class ReglamentoLlamadoAtencionViewSet(viewsets.ModelViewSet):
    queryset = ReglamentoLlamadoAtencion.objects.all()
    serializer_class = ReglamentoLlamadoAtencionSerializer
    

    
class LlamadoAtenciondViewSet(viewsets.ModelViewSet):
    queryset = LlamadoAtenciond.objects.all()
    serializer_class = LlamadoAtenciondSerializer
    
class AprendizLlamadoAtenciondViewSet(viewsets.ModelViewSet):
    queryset = AprendizLlamadoAtenciond.objects.all()
    serializer_class = AprendizLlamadoAtenciondSerializer
    
class InstructorLlamadoAtenciondViewSet(viewsets.ModelViewSet):
    queryset = InstructorLlamadoAtenciond.objects.all()
    serializer_class = InstructorLlamadoAtenciondSerializer
    
class ReglamentoLlamadoAtenciondViewSet(viewsets.ModelViewSet):
    queryset = ReglamentoLlamadoAtenciond.objects.all()
    serializer_class = ReglamentoLlamadoAtenciondSerializer
    

    
    
class SolicitudViewSet(viewsets.ModelViewSet):
    queryset = Solicitud.objects.all()
    serializer_class = SolicitudSerializer
    
class AprendizSolicitudViewSet(viewsets.ModelViewSet):
    queryset = AprendizSolicitud.objects.all()
    serializer_class = AprendizSolicitudSerializer
    
class InstructorSolicitudViewSet(viewsets.ModelViewSet):
    queryset = InstructorSolicitud.objects.all()
    serializer_class = InstructorSolicitudSerializer
    
class ReglamentoSolicitudViewSet(viewsets.ModelViewSet):
    queryset = ReglamentoSolicitud.objects.all()
    serializer_class = ReglamentoSolicitudSerializer

class CitacionViewSet(viewsets.ModelViewSet):
    queryset = Citacion.objects.all()
    serializer_class = CitacionSerializer
    
class ActaViewSet(viewsets.ModelViewSet):
    queryset = Acta.objects.all()
    serializer_class = ActaSerializer
    


    
class SubirArchivo(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request, *args, **kwargs):
        serializer = ArchivoCitacionSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


    


@csrf_exempt
def send_email(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            subject = data.get("subject", "")
            message = data.get("message", "")
            from_email = EMAIL_HOST_USER
            recipient_list = data.get("recipient_list", [])

            # Convertir recipient_list a lista si se envía como string
            if isinstance(recipient_list, str):
                recipient_list = json.loads(recipient_list)

            # Validar que recipient_list sea una lista después de la conversión
            if not isinstance(recipient_list, list):
                return JsonResponse({"error": "El campo recipient_list debe ser una lista"}, status=400)

            # Obtener el archivo adjunto codificado en base64
            attachment_data = data.get("attachment")
            attachment_name = data.get("attachment_name", "attachment.pdf")

            if subject and message and from_email and recipient_list:
                try:
                    email = EmailMessage(
                        subject,
                        message,
                        from_email,
                        recipient_list,
                        connection=get_connection()
                    )

                    # Si hay un archivo adjunto, procesarlo
                    if attachment_data:
                        try:
                            decoded_file = base64.b64decode(attachment_data)
                            email.attach(attachment_name, decoded_file, 'application/pdf')
                        except (ValueError, TypeError) as e:
                            return JsonResponse({"error": f"Error al procesar el archivo adjunto: {str(e)}"}, status=400)

                    # Enviar el correo
                    email.send()
                    return JsonResponse({"message": "Correo electrónico enviado exitosamente"}, status=200)
                except BadHeaderError:
                    return JsonResponse({"error": "Error al enviar correo electrónico"}, status=400)
            else:
                return JsonResponse({"error": "Por favor, complete todos los campos"}, status=400)
        except json.JSONDecodeError:
            return JsonResponse({"error": "Error al procesar la solicitud JSON"}, status=400)
    else:
        return JsonResponse({"error": "Método no permitido"}, status=405)



# Función para actualizar el estado de la solicitud
@csrf_exempt
def actualizar_estado_solicitud(request, solicitud_id):
    if request.method == 'PATCH':
        try:
            # Convertir el cuerpo de la solicitud a JSON
            data = json.loads(request.body)
            
            # Buscar la solicitud en la base de datos
            solicitud = Solicitud.objects.get(id=solicitud_id)
            
            # Actualizar el atributo solicitudrechazada
            solicitud.solicitudrechazada = data.get('solicitudrechazada', False)
            solicitud.save()
            
            return JsonResponse({"message": "Solicitud actualizada correctamente"}, status=200)
        except Solicitud.DoesNotExist:
            return JsonResponse({"error": "Solicitud no encontrada"}, status=404)
        except Exception as e:
            return JsonResponse({"error": str(e)}, status=400)
    else:
        return JsonResponse({"error": "Método no permitido"}, status=405)
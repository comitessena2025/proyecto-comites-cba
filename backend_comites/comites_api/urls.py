from django.urls import path, include
from rest_framework import routers
from .views import *

router = routers.DefaultRouter()
router.register(r'UsuarioAprendiz', UsuarioAprendizViewSet, basename='UsuarioAprendiz')
router.register(r'Instructor', InstructorViewSet, basename='Instructor')
router.register(r'Abogado', AbogadoViewSet, basename='Abogado')
router.register(r'Coordinador', CoordinadorViewSet, basename='Coordinador')
router.register(r'Bienestar', BienestarViewSet, basename='Bienestar')
router.register(r'Radicacion', RadicacionViewSet, basename='Radicacion')
router.register(r'Reglamento', ReglamentoViewSet, basename='Reglamento')
router.register(r'llamadoAtencion', LlamadoAtencionViewSet, basename='llamadoAtencion')
router.register(r'AprendizLlamadoAtencion', AprendizLlamadoAtencionViewSet, basename='AprendizLlamadoAtencion')
router.register(r'InstructorLlamadoAtencion', InstructorLlamadoAtencionViewSet, basename='InstructorLlamadoAtencion')
router.register(r'ReglamentoLlamadoAtencion', ReglamentoLlamadoAtencionViewSet, basename='ReglamentoLlamadoAtencion')
router.register(r'llamadoAtenciond', LlamadoAtenciondViewSet, basename='llamadoAtenciond')
router.register(r'AprendizLlamadoAtenciond', AprendizLlamadoAtenciondViewSet, basename='AprendizLlamadoAtenciond')
router.register(r'InstructorLlamadoAtenciond', InstructorLlamadoAtenciondViewSet, basename='InstructorLlamadoAtenciond')
router.register(r'ReglamentoLlamadoAtenciond', ReglamentoLlamadoAtenciondViewSet, basename='ReglamentoLlamadoAtenciond')
router.register(r'Solicitud', SolicitudViewSet, basename='Solicitud')
router.register(r'AprendizSolicitud', AprendizSolicitudViewSet, basename='AprendizSolicitud')
router.register(r'InstructorSolicitud', InstructorSolicitudViewSet, basename='InstructorSolicitud')
router.register(r'ReglamentoSolicitud', ReglamentoSolicitudViewSet, basename='ReglamentoSolicitud')
router.register(r'Citacion', CitacionViewSet, basename='Citacion')
router.register(r'Acta', ActaViewSet, basename='Acta')
router.register(r'ArchivoCitacion', ArchivoCitacionViewSet, basename='ArchivoCitacion')




urlpatterns = [
    path('', include(router.urls)),
    path('send-email/', send_email, name='send-email'),
    path('api/actualizar-solicitud/<int:solicitud_id>/', actualizar_estado_solicitud, name='actualizar-estado-solicitud'),
    path('upload/', SubirArchivo.as_view(), name='subir_archivo'),
    
]
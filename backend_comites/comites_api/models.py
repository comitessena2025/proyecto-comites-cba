from django.db import models


# Create your models here.
class UsuarioAprendiz(models.Model):
    class TipoDocumentoA(models.TextChoices):
        TARJETAI = "TI", ('Tarjeta de Identidad')
        CEDULA = "CC", ('Cedula de Ciudadanía')
        EXTRANGERA = "CE", ('Cedula de Extranjería')
        PASAPORTE = "PAS", ('Pasaporte')
        NIT = "NIT", ('Número de identificación tributaria')
    class Coordinacion(models.TextChoices):
        COR1 = "1", ('1')
        COR2 = "2", ('2')
        COR3 = "3", ('3')
        COR4 = "4", ('4')

    class Roles(models.TextChoices):
        APRENDIZ ="APRENDIZ", ("APRENDIZ")
    class Genero(models.TextChoices):
        MASCULINO ="MASCULINO", ("MASCULINO")
        FEMENINO ="FEMENINO", ("FEMENINO")
        OTRO ="OTRO", ("OTRO")
    

    id = models.AutoField(primary_key=True)
    nombres = models.CharField(max_length=255, blank=False, null=False)
    apellidos = models.CharField(max_length=255, blank=False, null=False)
    tipoDocumento = models.CharField(max_length=255, choices=TipoDocumentoA.choices, default=TipoDocumentoA.CEDULA)
    numeroDocumento = models.CharField(max_length=255, blank=False, null=False)
    ficha = models.CharField(max_length=255, blank=False, null=False)
    programa = models.CharField(max_length=225, blank=False, null=False)
    correoElectronico = models.EmailField(max_length=225, blank=False, null=False)  # Usar EmailField en lugar de CharField para correos
    rol1 = models.CharField( max_length=15, choices=Roles.choices, default=Roles.APRENDIZ, blank=True, null=True)  # Se debe agregar max_length al campo CharField
    estado = models.BooleanField(default=True, blank=False, null=False)
    coordinacion= models.CharField( max_length=15, choices=Coordinacion.choices, null=False)
    llamadoatencionaprendiz= models.IntegerField(default=0, blank=False, null=False)
    comitecordinacion= models.BooleanField(default=False, blank=False, null=False)
    comitegeneral= models.BooleanField(default=False, blank=False, null=False)
    genero= models.CharField(default=Genero.OTRO,max_length=255, choices=Genero.choices,  blank=False, null=False)
    

class Instructor(models.Model):
    class TipoDocumento(models.TextChoices):
        TARJETAI = "TI", ('Tarjeta de Identidad')
        CEDULA = "CC", ('Cedula de Ciudadanía')
        EXTRANGERA = "CE", ('Cedula de Extranjería')
        PASAPORTE = "PAS", ('Pasaporte')
        NIT = "NIT", ('Número de identificación tributaria')
    
    class Coordinacion(models.TextChoices):
        COR1 = "1", ('1')
        COR2 = "2", ('2')
        COR3 = "3", ('3')
        COR4 = "4", ('4')
    class Roles(models.TextChoices):
        INSTRUCTOR = "INSTRUCTOR", ("INSTRUCTOR")
        
        
    id = models.AutoField(primary_key=True)
    nombres = models.CharField(max_length=255, blank=False, null=False)
    apellidos = models.CharField(max_length=255, blank=False, null=False)
    tipoDocumento = models.CharField(max_length=3, choices=TipoDocumento.choices, default=TipoDocumento.CEDULA)
    numeroDocumento = models.CharField(max_length=50, blank=False, null=False)
    correoElectronico = models.CharField(max_length=100, blank=False, null=False)
    rol1 = models.CharField(
        max_length=15, choices=Roles.choices, default=Roles.INSTRUCTOR, blank=True, null=True)
    coordinacion= models.CharField( max_length=15, choices=Coordinacion.choices, null=False)
    estado = models.BooleanField(default=True, blank=False, null=False)
    ficha = models.CharField(max_length=255, blank=False, null=False)
    
class Abogado(models.Model):
    class TipoDocumento(models.TextChoices):
        TARJETAI = "TI", ('Tarjeta de Identidad')
        CEDULA = "CC", ('Cedula de Ciudadanía')
        EXTRANGERA = "CE", ('Cedula de Extranjería')
        PASAPORTE = "PAS", ('Pasaporte')
        NIT = "NIT", ('Número de identificación tributaria')
        
    class Roles(models.TextChoices):
        
        ABOGADO = "ABOGADO", ('ABOGADO')
        
    
    
    id = models.AutoField(primary_key=True)
    nombres = models.CharField(max_length=255, blank=False, null=False)
    apellidos = models.CharField(max_length=255, blank=False, null=False)
    tipoDocumento = models.CharField(max_length=3, choices=TipoDocumento.choices, default=TipoDocumento.CEDULA)
    numeroDocumento = models.CharField(max_length=50, blank=False, null=False)
    correoElectronico = models.CharField(max_length=100, blank=False, null=False)
    rol1 = models.CharField(
        max_length=15, choices=Roles.choices, default=Roles.ABOGADO, blank=True, null=True)
    estado = models.BooleanField(default=True, blank=False, null=False)
    
class Coordinador(models.Model):
    class TipoDocumento(models.TextChoices):
        TARJETAI = "TI", ('Tarjeta de Identidad')
        CEDULA = "CC", ('Cedula de Ciudadanía')
        EXTRANGERA = "CE", ('Cedula de Extranjería')
        PASAPORTE = "PAS", ('Pasaporte')
        NIT = "NIT", ('Número de identificación tributaria')
    
    class Coordinacion(models.TextChoices):
        COR1 = "1", ('1')
        COR2 = "2", ('2')
        COR3 = "3", ('3')
        COR4 = "4", ('4')
        
    class Roles(models.TextChoices):
        COORDINADOR = "COORDINADOR", ('COORDINADOR')
        
        
    id = models.AutoField(primary_key=True)
    nombres = models.CharField(max_length=255, blank=False, null=False)
    apellidos = models.CharField(max_length=255, blank=False, null=False)
    tipoDocumento = models.CharField(max_length=3, choices=TipoDocumento.choices, default=TipoDocumento.CEDULA)
    numeroDocumento = models.CharField(max_length=50, blank=False, null=False)
    correoElectronico = models.CharField(max_length=100, blank=False, null=False)
    rol1 = models.CharField(
        max_length=15, choices=Roles.choices, default=Roles.COORDINADOR, blank=True, null=True)
    coordinacion= models.CharField( max_length=15, choices=Coordinacion.choices, null=False)
    estado = models.BooleanField(default=True, blank=False, null=False)

class Bienestar(models.Model):
    class TipoDocumento(models.TextChoices):
        TARJETAI = "TI", ('Tarjeta de Identidad')
        CEDULA = "CC", ('Cedula de Ciudadanía')
        EXTRANGERA = "CE", ('Cedula de Extranjería')
        PASAPORTE = "PAS", ('Pasaporte')
        NIT = "NIT", ('Número de identificación tributaria')
        
    class Roles(models.TextChoices):
        BIENESTAR = "BIENESTAR", ('BIENESTAR')
    id = models.AutoField(primary_key=True)
    nombres = models.CharField(max_length=255, blank=False, null=False)
    apellidos = models.CharField(max_length=255, blank=False, null=False)
    tipoDocumento = models.CharField(max_length=3, choices=TipoDocumento.choices, default=TipoDocumento.CEDULA)
    numeroDocumento = models.CharField(max_length=50, blank=False, null=False)
    correoElectronico = models.CharField(max_length=100, blank=False, null=False)
    rol1 = models.CharField(
        max_length=15, choices=Roles.choices, default=Roles.BIENESTAR, blank=True, null=True)
    estado = models.BooleanField(default=True, blank=False, null=False)
    
    
class Radicacion(models.Model):
    class TipoDocumento(models.TextChoices):
        CEDULA = "CC", ('Cedula de Ciudadanía')
        EXTRANGERA = "CE", ('Cedula de Extranjería')
        PASAPORTE = "PAS", ('Pasaporte')
        NIT = "NIT", ('Número de identificación tributaria')
        
    class Roles(models.TextChoices):
        RADICACION = "RADICACION", ('RADICACION')
    id = models.AutoField(primary_key=True)
    nombres = models.CharField(max_length=255, blank=False, null=False)
    apellidos = models.CharField(max_length=255, blank=False, null=False)
    tipoDocumento = models.CharField(max_length=3, choices=TipoDocumento.choices, default=TipoDocumento.CEDULA)
    numeroDocumento = models.CharField(max_length=50, blank=False, null=False)
    correoElectronico = models.CharField(max_length=100, blank=False, null=False)
    rol1 = models.CharField(
        max_length=15, choices=Roles.choices, default=Roles.RADICACION, blank=True, null=True)
    estado = models.BooleanField(default=True, blank=False, null=False)


    



class Reglamento(models.Model):
    id = models.AutoField(primary_key=True)
    capitulo = models.CharField(blank=False, null=False)# Eliminar max_length, ya que no aplica a IntegerField
    numeral = models.CharField(blank=False, null=False)  # Eliminar max_length, ya que no aplica a IntegerField
    descripcion = models.CharField(max_length=1000, blank=False, null=False)
    academico = models.BooleanField(default=True, blank=False, null=False)
    disciplinario = models.BooleanField(default=True, blank=False, null=False)
    gravedad= models.CharField(max_length=250, blank=False, null=False)
    
class llamadoAtencion(models.Model):
    id = models.AutoField(primary_key=True)
    aprendiz = models.ManyToManyField('UsuarioAprendiz', through='AprendizLlamadoAtencion')
    fechallamadoatencion = models.DateTimeField(auto_now_add=True)
    descripcion = models.CharField(max_length=600, blank=False, null=False)
    observaciones = models.CharField(max_length=300, blank=False, null=False)
    responsable = models.ManyToManyField('Instructor', through='InstructorLlamadoAtencion')  # Asegúrate de que 'Usuario' esté definido en tu proyecto
    reglamento = models.ManyToManyField('Reglamento', through='ReglamentoLlamadoAtencion')
    llamadodeatencion= models.BooleanField(default=True)#  Cambiado 'Reglamento' para seguir la convención de minúsculas
    numerollamadosatencion= models.IntegerField(default=1)
    
class AprendizLlamadoAtencion(models.Model):
    id = models.AutoField(primary_key=True)
    aprendiz = models.ForeignKey(UsuarioAprendiz, on_delete=models.CASCADE)
    llamadoatencion = models.ForeignKey(llamadoAtencion, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('aprendiz', 'llamadoatencion')

        
class InstructorLlamadoAtencion(models.Model):
    id = models.AutoField(primary_key=True)
    usuario = models.ForeignKey(Instructor, on_delete=models.CASCADE)  # Verifica que el modelo 'Usuario' esté correctamente definido
    llamadoatencion = models.ForeignKey(llamadoAtencion, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('usuario', 'llamadoatencion')

    
    
class ReglamentoLlamadoAtencion(models.Model):
    id = models.AutoField(primary_key=True)
    reglamento = models.ForeignKey(Reglamento, on_delete=models.CASCADE)
    llamadoatencion = models.ForeignKey(llamadoAtencion, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('reglamento', 'llamadoatencion')


class LlamadoAtenciond(models.Model):
    id = models.AutoField(primary_key=True)
    aprendiz = models.ManyToManyField('UsuarioAprendiz', through='AprendizLlamadoAtenciond')
    fechallamadoatencion = models.DateTimeField(auto_now_add=True)
    descripcion = models.CharField(max_length=600, blank=False, null=False)
    observaciones = models.CharField(max_length=300, blank=False, null=False)
    responsable = models.ManyToManyField('Instructor', through='InstructorLlamadoAtenciond')
    reglamento = models.ManyToManyField('Reglamento', through='ReglamentoLlamadoAtenciond')
    llamadodeatencion2 = models.BooleanField(default=True)


class AprendizLlamadoAtenciond(models.Model):
    id = models.AutoField(primary_key=True)
    aprendiz = models.ForeignKey('UsuarioAprendiz', on_delete=models.CASCADE)
    llamadoatencion = models.ForeignKey('LlamadoAtenciond', on_delete=models.CASCADE)

    class Meta:
        unique_together = ('aprendiz', 'llamadoatencion')


class InstructorLlamadoAtenciond(models.Model):
    id = models.AutoField(primary_key=True)
    instructor = models.ForeignKey('Instructor', on_delete=models.CASCADE)
    llamadoatencion = models.ForeignKey('LlamadoAtenciond', on_delete=models.CASCADE)

    class Meta:
        unique_together = ('instructor', 'llamadoatencion')


class ReglamentoLlamadoAtenciond(models.Model):
    id = models.AutoField(primary_key=True)
    reglamento = models.ForeignKey('Reglamento', on_delete=models.CASCADE)
    llamadoatencion = models.ForeignKey('LlamadoAtenciond', on_delete=models.CASCADE)

    class Meta:
        unique_together = ('reglamento', 'llamadoatencion')

    
class Solicitud(models.Model):
    id = models.AutoField(primary_key=True)
    aprendiz = models.ManyToManyField('UsuarioAprendiz', through='AprendizSolicitud')
    fechasolicitud = models.DateTimeField(auto_now_add=True)
    descripcion = models.CharField(max_length=600, blank=False, null=False)
    observaciones = models.CharField(max_length=300, blank=False, null=False)
    responsable = models.ManyToManyField('Instructor', through='InstructorSolicitud')  # Asegúrate de que 'Usuario' esté definido en tu proyecto
    reglamento = models.ManyToManyField('Reglamento', through='ReglamentoSolicitud')
    solicitudenviada= models.BooleanField(default=True)#  Cambiado 'Reglamento' para seguir la convención de minúsculas
    solicitudaceptada= models.BooleanField(default=False)
    coordinacionaceptada= models.BooleanField(default=False)
    solicitudrechazada=models.BooleanField(default=False)
    citacionenviada = models.BooleanField(default=False)
    comiteenviado = models.BooleanField(default=False)
    planmejoramiento = models.BooleanField(default=False)
    pmsubidoinstructor=models.BooleanField(default=False)
    pmsubidoaprendiz=models.BooleanField(default=False)
    desicoordinador= models.BooleanField(default=False)
    desiabogada= models.BooleanField(default=False)
    finalizado = models.BooleanField(default=False)
    name_fildsolicitud1 = models.CharField(max_length=255, blank=True, null=True)
    filesolicitud1 = models.URLField(blank=True, null=True)
    name_fildsolicitud2 = models.CharField(max_length=255, blank=True, null=True)
    filesolicitud2 = models.URLField(blank=True, null=True)
    name_fildsolicitud3 = models.CharField(max_length=255, blank=True, null=True)
    filesolicitud3 = models.URLField(blank=True, null=True)
    name_fildsolicitud4 = models.CharField(max_length=255, blank=True, null=True)
    filesolicitud4 = models.URLField(blank=True, null=True)
    
class AprendizSolicitud(models.Model):
    id = models.AutoField(primary_key=True)
    aprendiz = models.ForeignKey(UsuarioAprendiz, on_delete=models.CASCADE)
    solicitud = models.ForeignKey(Solicitud, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('aprendiz', 'solicitud')

        
class InstructorSolicitud(models.Model):
    id = models.AutoField(primary_key=True)
    usuario = models.ForeignKey(Instructor, on_delete=models.CASCADE)  # Verifica que el modelo 'Usuario' esté correctamente definido
    solicitud = models.ForeignKey(Solicitud, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('usuario', 'solicitud')

    
    
class ReglamentoSolicitud(models.Model):
    id = models.AutoField(primary_key=True)
    reglamento = models.ForeignKey(Reglamento, on_delete=models.CASCADE)
    solicitud = models.ForeignKey(Solicitud, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('reglamento', 'solicitud')

class Citacion(models.Model):
    id = models.AutoField(primary_key=True)
    solicitud = models.ForeignKey(Solicitud, on_delete=models.CASCADE)
    diacitacion = models.DateTimeField()  # Cambiado a DateTimeField
    horainicio = models.TimeField()
    horafin = models.TimeField()
    lugarcitacion = models.CharField(max_length=600, blank=False, null=False)
    enlacecitacion = models.CharField(max_length=600, blank=False, null=False)
    actarealizada= models.BooleanField(default=False)
    numeroderadicado= models.CharField(max_length=255, blank=False, null=True)
    radicado=models.BooleanField(default=False)
    
class Acta(models.Model):
    
    class clasificacion(models.TextChoices):
        PUBLICA = "PUBLICA", ('PUBLICA')
        PRIVADO = "PRIVADO", ('PRIVADO')
        SEMIPRIVADO = "SEMIPRIVADO", ('SEMIPRIVADO')
        SENSISBLE = "SENSISBLE", ('SENSISBLE')

    id = models.AutoField(primary_key=True)
    citacion = models.ForeignKey(Citacion, on_delete=models.CASCADE)
    verificacionquorom = models.CharField(max_length=600, blank=False, null=False)
    verificacionasistenciaaprendiz = models.CharField(max_length=600, blank=False, null=False)
    verificacionbeneficio = models.CharField(max_length=600, blank=False, null=False)
    reporte = models.CharField(max_length=600, blank=False, null=False)
    descargos = models.CharField(max_length=600, blank=False, null=False)
    pruebas = models.CharField(max_length=600, blank=False, null=False)
    deliberacion = models.CharField(max_length=600, blank=False, null=False)
    votos = models.CharField(max_length=600, blank=False, null=False)
    conclusiones = models.CharField(max_length=600, blank=False, null=False)
    clasificacioninformacion= models.CharField( max_length=15, choices=clasificacion.choices, default=clasificacion.PUBLICA, blank=True, null=True)
    

    
class ArchivoCitacion(models.Model):
    citacion = models.ForeignKey('Citacion', on_delete=models.CASCADE, related_name='archivos')
    file = models.URLField()
    uploaded_at = models.DateTimeField(auto_now_add=True)
    archivo_url = models.URLField(max_length=500, null=True, blank=True)

    def __str__(self):
        return f"Archivo para citación {self.citacion.id}"
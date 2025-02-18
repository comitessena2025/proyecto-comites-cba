# Generated by Django 5.1.1 on 2025-01-28 18:57

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('comites_api', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Abogado',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('nombres', models.CharField(max_length=255)),
                ('apellidos', models.CharField(max_length=255)),
                ('tipoDocumento', models.CharField(choices=[('TI', 'Tarjeta de Identidad'), ('CC', 'Cedula de Ciudadanía'), ('CE', 'Cedula de Extranjería'), ('PAS', 'Pasaporte'), ('NIT', 'Número de identificación tributaria')], default='CC', max_length=3)),
                ('numeroDocumento', models.CharField(max_length=50)),
                ('correoElectronico', models.CharField(max_length=100)),
                ('rol1', models.CharField(blank=True, choices=[('ABOGADO', 'ABOGADO')], default='ABOGADO', max_length=15, null=True)),
                ('estado', models.BooleanField(default=True)),
            ],
        ),
        migrations.CreateModel(
            name='Bienestar',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('nombres', models.CharField(max_length=255)),
                ('apellidos', models.CharField(max_length=255)),
                ('tipoDocumento', models.CharField(choices=[('TI', 'Tarjeta de Identidad'), ('CC', 'Cedula de Ciudadanía'), ('CE', 'Cedula de Extranjería'), ('PAS', 'Pasaporte'), ('NIT', 'Número de identificación tributaria')], default='CC', max_length=3)),
                ('numeroDocumento', models.CharField(max_length=50)),
                ('correoElectronico', models.CharField(max_length=100)),
                ('rol1', models.CharField(blank=True, choices=[('BIENESTAR', 'BIENESTAR')], default='BIENESTAR', max_length=15, null=True)),
                ('estado', models.BooleanField(default=True)),
            ],
        ),
        migrations.CreateModel(
            name='Citacion',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('diacitacion', models.DateTimeField()),
                ('horainicio', models.TimeField()),
                ('horafin', models.TimeField()),
                ('lugarcitacion', models.CharField(max_length=600)),
                ('enlacecitacion', models.CharField(max_length=600)),
                ('actarealizada', models.BooleanField(default=False)),
                ('numeroderadicado', models.CharField(max_length=255, null=True)),
                ('radicado', models.BooleanField(default=False)),
            ],
        ),
        migrations.CreateModel(
            name='Coordinador',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('nombres', models.CharField(max_length=255)),
                ('apellidos', models.CharField(max_length=255)),
                ('tipoDocumento', models.CharField(choices=[('TI', 'Tarjeta de Identidad'), ('CC', 'Cedula de Ciudadanía'), ('CE', 'Cedula de Extranjería'), ('PAS', 'Pasaporte'), ('NIT', 'Número de identificación tributaria')], default='CC', max_length=3)),
                ('numeroDocumento', models.CharField(max_length=50)),
                ('correoElectronico', models.CharField(max_length=100)),
                ('rol1', models.CharField(blank=True, choices=[('COORDINADOR', 'COORDINADOR')], default='COORDINADOR', max_length=15, null=True)),
                ('coordinacion', models.CharField(choices=[('1', '1'), ('2', '2'), ('3', '3'), ('4', '4')], max_length=15)),
                ('estado', models.BooleanField(default=True)),
            ],
        ),
        migrations.CreateModel(
            name='Instructor',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('nombres', models.CharField(max_length=255)),
                ('apellidos', models.CharField(max_length=255)),
                ('tipoDocumento', models.CharField(choices=[('TI', 'Tarjeta de Identidad'), ('CC', 'Cedula de Ciudadanía'), ('CE', 'Cedula de Extranjería'), ('PAS', 'Pasaporte'), ('NIT', 'Número de identificación tributaria')], default='CC', max_length=3)),
                ('numeroDocumento', models.CharField(max_length=50)),
                ('correoElectronico', models.CharField(max_length=100)),
                ('rol1', models.CharField(blank=True, choices=[('INSTRUCTOR', 'INSTRUCTOR')], default='INSTRUCTOR', max_length=15, null=True)),
                ('coordinacion', models.CharField(choices=[('1', '1'), ('2', '2'), ('3', '3'), ('4', '4')], max_length=15)),
                ('estado', models.BooleanField(default=True)),
                ('ficha', models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='Radicacion',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('nombres', models.CharField(max_length=255)),
                ('apellidos', models.CharField(max_length=255)),
                ('tipoDocumento', models.CharField(choices=[('CC', 'Cedula de Ciudadanía'), ('CE', 'Cedula de Extranjería'), ('PAS', 'Pasaporte'), ('NIT', 'Número de identificación tributaria')], default='CC', max_length=3)),
                ('numeroDocumento', models.CharField(max_length=50)),
                ('correoElectronico', models.CharField(max_length=100)),
                ('rol1', models.CharField(blank=True, choices=[('RADICACION', 'RADICACION')], default='RADICACION', max_length=15, null=True)),
                ('estado', models.BooleanField(default=True)),
            ],
        ),
        migrations.CreateModel(
            name='Reglamento',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('capitulo', models.CharField()),
                ('numeral', models.CharField()),
                ('descripcion', models.CharField(max_length=1000)),
                ('academico', models.BooleanField(default=True)),
                ('disciplinario', models.BooleanField(default=True)),
                ('gravedad', models.CharField(max_length=250)),
            ],
        ),
        migrations.CreateModel(
            name='UsuarioAprendiz',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('nombres', models.CharField(max_length=255)),
                ('apellidos', models.CharField(max_length=255)),
                ('tipoDocumento', models.CharField(choices=[('TI', 'Tarjeta de Identidad'), ('CC', 'Cedula de Ciudadanía'), ('CE', 'Cedula de Extranjería'), ('PAS', 'Pasaporte'), ('NIT', 'Número de identificación tributaria')], default='CC', max_length=255)),
                ('numeroDocumento', models.CharField(max_length=255)),
                ('ficha', models.CharField(max_length=255)),
                ('programa', models.CharField(max_length=225)),
                ('correoElectronico', models.EmailField(max_length=225)),
                ('rol1', models.CharField(blank=True, choices=[('APRENDIZ', 'APRENDIZ')], default='APRENDIZ', max_length=15, null=True)),
                ('estado', models.BooleanField(default=True)),
                ('coordinacion', models.CharField(choices=[('1', '1'), ('2', '2'), ('3', '3'), ('4', '4')], max_length=15)),
                ('llamadoatencionaprendiz', models.IntegerField(default=0)),
                ('comitecordinacion', models.BooleanField(default=False)),
                ('comitegeneral', models.BooleanField(default=False)),
            ],
        ),
        migrations.CreateModel(
            name='ArchivoCitacion',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('file', models.URLField()),
                ('uploaded_at', models.DateTimeField(auto_now_add=True)),
                ('archivo_url', models.URLField(blank=True, max_length=500, null=True)),
                ('citacion', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='archivos', to='comites_api.citacion')),
            ],
        ),
        migrations.CreateModel(
            name='Acta',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('verificacionquorom', models.CharField(max_length=600)),
                ('verificacionasistenciaaprendiz', models.CharField(max_length=600)),
                ('verificacionbeneficio', models.CharField(max_length=600)),
                ('reporte', models.CharField(max_length=600)),
                ('descargos', models.CharField(max_length=600)),
                ('pruebas', models.CharField(max_length=600)),
                ('deliberacion', models.CharField(max_length=600)),
                ('votos', models.CharField(max_length=600)),
                ('conclusiones', models.CharField(max_length=600)),
                ('clasificacioninformacion', models.CharField(blank=True, choices=[('PUBLICA', 'PUBLICA'), ('PRIVADO', 'PRIVADO'), ('SEMIPRIVADO', 'SEMIPRIVADO'), ('SENSISBLE', 'SENSISBLE')], default='PUBLICA', max_length=15, null=True)),
                ('citacion', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.citacion')),
            ],
        ),
        migrations.CreateModel(
            name='InstructorLlamadoAtencion',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('usuario', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.instructor')),
            ],
        ),
        migrations.CreateModel(
            name='InstructorLlamadoAtenciond',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('instructor', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.instructor')),
            ],
        ),
        migrations.CreateModel(
            name='InstructorSolicitud',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('usuario', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.instructor')),
            ],
        ),
        migrations.CreateModel(
            name='llamadoAtencion',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('fechallamadoatencion', models.DateTimeField(auto_now_add=True)),
                ('descripcion', models.CharField(max_length=600)),
                ('observaciones', models.CharField(max_length=300)),
                ('llamadodeatencion', models.BooleanField(default=True)),
                ('numerollamadosatencion', models.IntegerField(default=1)),
                ('responsable', models.ManyToManyField(through='comites_api.InstructorLlamadoAtencion', to='comites_api.instructor')),
            ],
        ),
        migrations.AddField(
            model_name='instructorllamadoatencion',
            name='llamadoatencion',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.llamadoatencion'),
        ),
        migrations.CreateModel(
            name='AprendizLlamadoAtencion',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('llamadoatencion', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.llamadoatencion')),
                ('aprendiz', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.usuarioaprendiz')),
            ],
            options={
                'unique_together': {('aprendiz', 'llamadoatencion')},
            },
        ),
        migrations.CreateModel(
            name='LlamadoAtenciond',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('fechallamadoatencion', models.DateTimeField(auto_now_add=True)),
                ('descripcion', models.CharField(max_length=600)),
                ('observaciones', models.CharField(max_length=300)),
                ('llamadodeatencion2', models.BooleanField(default=True)),
                ('responsable', models.ManyToManyField(through='comites_api.InstructorLlamadoAtenciond', to='comites_api.instructor')),
            ],
        ),
        migrations.AddField(
            model_name='instructorllamadoatenciond',
            name='llamadoatencion',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.llamadoatenciond'),
        ),
        migrations.CreateModel(
            name='AprendizLlamadoAtenciond',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('llamadoatencion', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.llamadoatenciond')),
                ('aprendiz', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.usuarioaprendiz')),
            ],
            options={
                'unique_together': {('aprendiz', 'llamadoatencion')},
            },
        ),
        migrations.CreateModel(
            name='ReglamentoLlamadoAtencion',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('llamadoatencion', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.llamadoatencion')),
                ('reglamento', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.reglamento')),
            ],
            options={
                'unique_together': {('reglamento', 'llamadoatencion')},
            },
        ),
        migrations.AddField(
            model_name='llamadoatencion',
            name='reglamento',
            field=models.ManyToManyField(through='comites_api.ReglamentoLlamadoAtencion', to='comites_api.reglamento'),
        ),
        migrations.CreateModel(
            name='ReglamentoLlamadoAtenciond',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('llamadoatencion', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.llamadoatenciond')),
                ('reglamento', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.reglamento')),
            ],
            options={
                'unique_together': {('reglamento', 'llamadoatencion')},
            },
        ),
        migrations.AddField(
            model_name='llamadoatenciond',
            name='reglamento',
            field=models.ManyToManyField(through='comites_api.ReglamentoLlamadoAtenciond', to='comites_api.reglamento'),
        ),
        migrations.CreateModel(
            name='ReglamentoSolicitud',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('reglamento', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.reglamento')),
            ],
        ),
        migrations.CreateModel(
            name='Solicitud',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('fechasolicitud', models.DateTimeField(auto_now_add=True)),
                ('descripcion', models.CharField(max_length=600)),
                ('observaciones', models.CharField(max_length=300)),
                ('solicitudenviada', models.BooleanField(default=True)),
                ('solicitudaceptada', models.BooleanField(default=False)),
                ('coordinacionaceptada', models.BooleanField(default=False)),
                ('solicitudrechazada', models.BooleanField(default=False)),
                ('citacionenviada', models.BooleanField(default=False)),
                ('comiteenviado', models.BooleanField(default=False)),
                ('planmejoramiento', models.BooleanField(default=False)),
                ('pmsubidoinstructor', models.BooleanField(default=False)),
                ('pmsubidoaprendiz', models.BooleanField(default=False)),
                ('desicoordinador', models.BooleanField(default=False)),
                ('desiabogada', models.BooleanField(default=False)),
                ('finalizado', models.BooleanField(default=False)),
                ('name_fildsolicitud1', models.CharField(blank=True, max_length=255, null=True)),
                ('filesolicitud1', models.URLField(blank=True, null=True)),
                ('name_fildsolicitud2', models.CharField(blank=True, max_length=255, null=True)),
                ('filesolicitud2', models.URLField(blank=True, null=True)),
                ('name_fildsolicitud3', models.CharField(blank=True, max_length=255, null=True)),
                ('filesolicitud3', models.URLField(blank=True, null=True)),
                ('name_fildsolicitud4', models.CharField(blank=True, max_length=255, null=True)),
                ('filesolicitud4', models.URLField(blank=True, null=True)),
                ('reglamento', models.ManyToManyField(through='comites_api.ReglamentoSolicitud', to='comites_api.reglamento')),
                ('responsable', models.ManyToManyField(through='comites_api.InstructorSolicitud', to='comites_api.instructor')),
            ],
        ),
        migrations.AddField(
            model_name='reglamentosolicitud',
            name='solicitud',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.solicitud'),
        ),
        migrations.AddField(
            model_name='instructorsolicitud',
            name='solicitud',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.solicitud'),
        ),
        migrations.AddField(
            model_name='citacion',
            name='solicitud',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.solicitud'),
        ),
        migrations.CreateModel(
            name='AprendizSolicitud',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('solicitud', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.solicitud')),
                ('aprendiz', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='comites_api.usuarioaprendiz')),
            ],
            options={
                'unique_together': {('aprendiz', 'solicitud')},
            },
        ),
        migrations.AddField(
            model_name='solicitud',
            name='aprendiz',
            field=models.ManyToManyField(through='comites_api.AprendizSolicitud', to='comites_api.usuarioaprendiz'),
        ),
        migrations.AddField(
            model_name='llamadoatenciond',
            name='aprendiz',
            field=models.ManyToManyField(through='comites_api.AprendizLlamadoAtenciond', to='comites_api.usuarioaprendiz'),
        ),
        migrations.AddField(
            model_name='llamadoatencion',
            name='aprendiz',
            field=models.ManyToManyField(through='comites_api.AprendizLlamadoAtencion', to='comites_api.usuarioaprendiz'),
        ),
        migrations.AlterUniqueTogether(
            name='instructorllamadoatencion',
            unique_together={('usuario', 'llamadoatencion')},
        ),
        migrations.AlterUniqueTogether(
            name='instructorllamadoatenciond',
            unique_together={('instructor', 'llamadoatencion')},
        ),
        migrations.AlterUniqueTogether(
            name='reglamentosolicitud',
            unique_together={('reglamento', 'solicitud')},
        ),
        migrations.AlterUniqueTogether(
            name='instructorsolicitud',
            unique_together={('usuario', 'solicitud')},
        ),
    ]

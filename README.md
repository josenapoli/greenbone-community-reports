# 📘 Greenbone Community Reports (Español)
Formato de informe **Ejecutivo en PDF** personalizado para *Greenbone Community Edition (OpenVAS)*.

## 📄 Descripción
Este proyecto proporciona una **plantilla de informe en PDF de nivel ejecutivo**,  
centrada en métricas agregadas de vulnerabilidades, promedios CVSS y hallazgos principales.

Está diseñada para reportes orientados a **dirección y gestión**,  
brindando una visión general del estado de seguridad sin incluir detalles técnicos innecesarios.

---

## 🧰 Instalación paso a paso

### 1️⃣ Localizar el formato PDF base

Listar los formatos disponibles:
```bash
ls /var/lib/gvm/gvmd/report_formats/
```

Copiar el UUID del formato PDF base (por lo general c402cc3e-b531-11e1-9163-406186ea4fc5).

Duplicar el formato base

Ejecutar el siguiente comando para crear una copia:

```bash
sudo -u gvm gvm-cli socket --socket /run/gvmd/gvmd.sock --xml "
<create_report_format>
  <copy>c402cc3e-b531-11e1-9163-406186ea4fc5</copy>
  <name>PDF Executive Summary</name>
  <summary>Informe ejecutivo de vulnerabilidades (métricas agregadas, sin detalles técnicos)</summary>
</create_report_format>"
```

Si se solicita autenticación, ingresar las credenciales del usuario admin de Greenbone.

Verificar que se haya creado correctamente

```bash
sudo -u gvm psql gvmd -c "SELECT id, name, uuid FROM report_formats;"
```

Deberías ver algo como:

7 | PDF Executive Summary | 0bf5fd0f-c98b-4aa2-847c-228be530556b

Agregar parámetros configurables (opcional)

Si se desea que el formato sea configurable desde la interfaz GSA:

```bash
sudo -u gvm psql gvmd -c "
INSERT INTO report_format_params (report_format, name, type, value)
VALUES
 (7, 'Incluir vulnerabilidades bajas', 0, 'false'),
 (7, 'Incluir vulnerabilidades medias', 0, 'true'),
 (7, 'Incluir vulnerabilidades altas', 0, 'true'),
 (7, 'Incluir vulnerabilidades críticas', 0, 'true'),
 (7, 'Incluir gráfico resumen CVSS', 0, 'true'),
 (7, 'Incluir tabla de hosts', 0, 'false'),
 (7, 'Incluir gráfico de tendencias ejecutivas', 0, 'true'),
 (7, 'Incluir Top 10 de vulnerabilidades', 0, 'true'),
 (7, 'Incluir resumen de soluciones', 0, 'true'),
 (7, 'Título personalizado', 2, 'Informe Ejecutivo de Vulnerabilidades'),
 (7, 'Texto de pie de página', 2, 'Confidencial – Uso Interno Únicamente');
"
```

Importar los archivos del formato Executive Summary

Copiar la carpeta del formato personalizado dentro del directorio del UUID padre:

```bash
cd /var/lib/gvm/gvmd/report_formats/<UUID_base>/
sudo cp -r 0bf5fd0f-c98b-4aa2-847c-228be530556b /var/lib/gvm/gvmd/report_formats/<UUID_base>/
sudo chown -R gvm:gvm /var/lib/gvm/gvmd/report_formats/<UUID_base>/0bf5fd0f-c98b-4aa2-847c-228be530556b
sudo chmod -R 750 /var/lib/gvm/gvmd/report_formats/<UUID_base>/0bf5fd0f-c98b-4aa2-847c-228be530556b
```

Registrar el formato en la base de datos

```bash
sudo -u gvm gvmd --create-report-format \
/var/lib/gvm/gvmd/report_formats/<UUID_base>/0bf5fd0f-c98b-4aa2-847c-228be530556b/report_format.xml
```

Validar que se haya importado correctamente

```bash
sudo -u gvm psql gvmd -c "SELECT id, name, extension, content_type FROM report_formats WHERE name ILIKE '%executive%';"
```

Debería devolver algo como:

id                                    | name                         | extension | content_type

0bf5fd0f-c98b-4aa2-847c-228be530556b  | Executive Summary PDF (ES)   | pdf       | application/pdf

Ejemplo de estructura de archivos

Dentro de la carpeta del formato (0bf5fd0f-c98b-4aa2-847c-228be530556b/) se deben incluir:

generate

latex.xsl

report.xsl

report_format.xml



Archivos principales

generate → Script que ejecuta xsltproc y pdflatex

latex.xsl → Plantilla principal en LaTeX

report_format.xml → Descriptor XML del formato para gvmd

report.xsl → Transformación auxiliar (opcional)



EXTRA:

Migración a otro servidor:

Para reutilizar el formato en otra instalación:
Comprimir la carpeta:
tar czf ExecutiveSummary.tar.gz /var/lib/gvm/gvmd/report_formats/<UUID_base>/0bf5fd0f-c98b-4aa2-847c-228be530556b
Copiarla al nuevo servidor y extraerla en la misma ruta.
Ejecutar:
sudo -u gvm gvmd --create-report-format /var/lib/gvm/gvmd/report_formats/<UUID_base>/0bf5fd0f-c98b-4aa2-847c-228be530556b/report_format.xml

Autor

José Andrés Napoli
Analista de Seguridad Informática

📧 Contacto: jose.andres.napoli

💼 Proyecto: General | Seguridad Informática

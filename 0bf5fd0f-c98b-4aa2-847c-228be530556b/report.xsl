<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:report="http://www.openvas.org/report"
  exclude-result-prefixes="report">

  <!-- ===================================================== -->
  <!--  INFORME EJECUTIVO DE VULNERABILIDADES – GVM          -->
  <!--  Autor: Analista de Seguridad Informática             -->
  <!--  Responsable: José Andrés Napoli                      -->
  <!-- ===================================================== -->

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>Informe Ejecutivo de Vulnerabilidades</title>
        <style>
          body {
            font-family: "Segoe UI", Arial, sans-serif;
            font-size: 11pt;
            color: #222;
            margin: 2.5em;
            line-height: 1.5;
          }
          h1 {
            text-align: center;
            color: #003366;
            border-bottom: 3px solid #003366;
            padding-bottom: 5px;
            margin-bottom: 1em;
          }
          h2 {
            color: #003366;
            border-left: 5px solid #003366;
            padding-left: 10px;
          }
          h3 { color: #004080; margin-top: 1.2em; }
          table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 0.8em;
            margin-bottom: 1.5em;
          }
          th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
          }
          th {
            background-color: #003366;
            color: white;
          }
          tr:nth-child(even) { background-color: #f9f9f9; }
          .critical { color: #B71C1C; font-weight: bold; }
          .high { color: #E65100; font-weight: bold; }
          .medium { color: #F9A825; font-weight: bold; }
          .low { color: #33691E; font-weight: bold; }
          .summary-box {
            border-left: 5px solid #003366;
            background-color: #f5f9ff;
            padding: 10px 15px;
            margin: 1em 0;
          }
          .footer {
            font-size: 9pt;
            color: #666;
            text-align: center;
            margin-top: 3em;
          }
          .footer strong { color: #003366; }
        </style>
      </head>

      <body>
        <h1>Informe Ejecutivo de Vulnerabilidades</h1>

        <div class="summary-box">
          <p>
            Este documento presenta un resumen ejecutivo de las vulnerabilidades detectadas
            durante el proceso de análisis. Su objetivo es brindar una visión clara del nivel
            de exposición de los sistemas y facilitar la toma de decisiones estratégicas en materia
            de ciberseguridad.
          </p>
        </div>

        <h2>Resumen General</h2>
        <xsl:variable name="total" select="count(report:report/report:results/report:result)"/>
        <xsl:variable name="critical" select="count(report:report/report:results/report:result[report:severity&gt;=9])"/>
        <xsl:variable name="high" select="count(report:report/report:results/report:result[report:severity&gt;=7 and report:severity&lt;9])"/>
        <xsl:variable name="medium" select="count(report:report/report:results/report:result[report:severity&gt;=4 and report:severity&lt;7])"/>
        <xsl:variable name="low" select="count(report:report/report:results/report:result[report:severity&lt;4])"/>
        <xsl:variable name="avg" select="sum(report:report/report:results/report:result/report:severity) div $total"/>

        <table>
          <tr>
            <th>Severidad</th>
            <th>Cantidad</th>
            <th>Porcentaje</th>
          </tr>
          <tr><td class="critical">Crítica</td><td><xsl:value-of select="$critical"/></td><td><xsl:value-of select="format-number($critical div $total * 100, '0.0')"/>%</td></tr>
          <tr><td class="high">Alta</td><td><xsl:value-of select="$high"/></td><td><xsl:value-of select="format-number($high div $total * 100, '0.0')"/>%</td></tr>
          <tr><td class="medium">Media</td><td><xsl:value-of select="$medium"/></td><td><xsl:value-of select="format-number($medium div $total * 100, '0.0')"/>%</td></tr>
          <tr><td class="low">Baja</td><td><xsl:value-of select="$low"/></td><td><xsl:value-of select="format-number($low div $total * 100, '0.0')"/>%</td></tr>
          <tr><th>Total</th><th colspan="2"><xsl:value-of select="$total"/></th></tr>
        </table>

        <p><strong>Puntaje promedio CVSS:</strong> <xsl:value-of select="format-number($avg, '0.0')"/></p>

        <h2>Principales Riesgos Detectados</h2>
        <p>
          A continuación, se listan las vulnerabilidades de mayor severidad, ordenadas por impacto potencial
          sobre la organización. Estas deben considerarse de atención prioritaria para su mitigación.
        </p>

        <table>
          <tr><th>#</th><th>Vulnerabilidad</th><th>Impacto</th><th>Descripción Breve</th></tr>
          <xsl:for-each select="report:report/report:results/report:result[report:severity &gt;= 7][position() &lt;= 10]">
            <tr>
              <td><xsl:value-of select="position()"/></td>
              <td><xsl:value-of select="report:name"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="report:severity &gt;= 9">Crítico</xsl:when>
                  <xsl:otherwise>Alto</xsl:otherwise>
                </xsl:choose>
              </td>
              <td><xsl:value-of select="substring(report:description, 1, 200)"/>...</td>
            </tr>
          </xsl:for-each>
        </table>

        <h2>Recomendaciones Estratégicas</h2>
        <ul>
          <li>Priorizar la mitigación de las vulnerabilidades críticas y altas detectadas.</li>
          <li>Implementar políticas de actualización periódica de sistemas y software.</li>
          <li>Revisar configuraciones inseguras en servidores y endpoints.</li>
          <li>Adoptar un proceso continuo de gestión de vulnerabilidades y revisiones mensuales.</li>
        </ul>

        <h2>Conclusión</h2>
        <p>
          Este informe refleja el estado actual de exposición frente a vulnerabilidades conocidas.
          La adopción de las medidas sugeridas permitirá reducir significativamente la superficie de ataque
          y fortalecer la postura de seguridad general de la organización.
        </p>

        <div class="footer">
          <p>Informe generado automáticamente por <strong>Greenbone Vulnerability Management</strong>.</p>
          <p><strong>Responsable del Análisis:</strong> José Andrés Napoli – Analista de Seguridad Informática</p>
          <p><em>Confidencial – Uso Interno Únicamente</em></p>
        </div>

      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>

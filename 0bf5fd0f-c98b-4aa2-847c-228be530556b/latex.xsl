<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:report="http://www.greenbone.net/report"
  exclude-result-prefixes="report">

  <xsl:output method="text" encoding="UTF-8"/>

  <!-- ===================================================== -->
  <!--  Informe Ejecutivo de Vulnerabilidades                -->
  <!--  Responsable: José Andrés Napoli                      -->
  <!-- ===================================================== -->

  <!-- Función para limpiar caracteres conflictivos -->
  <xsl:template name="escape-latex">
    <xsl:param name="text"/>
    <xsl:value-of select="translate($text,'_%&amp;#$\\{}~^','           ')"/>
  </xsl:template>

  <xsl:template match="/">

  <xsl:variable name="root" select="/*[local-name()='report']"/>
  <xsl:variable name="results" select="$root/*[local-name()='results']/*[local-name()='result']"/>
  <xsl:variable name="total" select="count($results)"/>
  <xsl:variable name="critical" select="count($results[number(*[local-name()='severity']) &gt;= 9])"/>
  <xsl:variable name="high" select="count($results[number(*[local-name()='severity']) &gt;= 7 and number(*[local-name()='severity']) &lt; 9])"/>
  <xsl:variable name="medium" select="count($results[number(*[local-name()='severity']) &gt;= 4 and number(*[local-name()='severity']) &lt; 7])"/>
  <xsl:variable name="low" select="count($results[number(*[local-name()='severity']) &lt; 4])"/>
  <xsl:variable name="total_sev" select="sum($results/*[local-name()='severity'])"/>
  <xsl:variable name="avg" select="$total_sev div $total"/>

<![CDATA[
\documentclass[11pt,a4paper]{article}
\usepackage[spanish]{babel}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{geometry}
\usepackage{graphicx}
\usepackage[table]{xcolor}
\usepackage{longtable}
\usepackage{fancyhdr}
\usepackage{lastpage}
\geometry{margin=2cm}
\definecolor{gray20}{gray}{0.9}
\pagestyle{fancy}
\fancyhf{}
\rhead{Informe Ejecutivo de Vulnerabilidades}
\lhead{Greenbone Vulnerability Management}
\rfoot{Página \thepage\ de \pageref{LastPage}}
\setlength{\parskip}{6pt}

\begin{document}

\begin{center}
{\Huge \textbf{Informe Ejecutivo de Vulnerabilidades}} \\[1ex]
{\large \textbf{Análisis general de exposición tecnológica}} \\[2ex]
\textbf{Responsable del Análisis:} José Andrés Napoli – Analista de Seguridad Informática
\end{center}

\vspace{1cm}

Este informe ejecutivo presenta un resumen consolidado de las vulnerabilidades detectadas durante el análisis.
Su propósito es brindar una visión estratégica del estado de ciberseguridad, ayudando a priorizar la remediación
de los hallazgos más relevantes.

\vspace{1cm}

\section*{Resumen General}
A continuación se muestra la distribución de vulnerabilidades detectadas según su nivel de severidad.

\begin{longtable}{|l|c|c|}
\hline
\rowcolor{gray20}
\textbf{Severidad} & \textbf{Cantidad} & \textbf{Porcentaje} \\
\hline
Crítica & ]]><xsl:value-of select="$critical"/><![CDATA[ & ]]><xsl:value-of select="format-number(($critical div $total)*100,'0.0')"/><![CDATA[\% \\
Alta & ]]><xsl:value-of select="$high"/><![CDATA[ & ]]><xsl:value-of select="format-number(($high div $total)*100,'0.0')"/><![CDATA[\% \\
Media & ]]><xsl:value-of select="$medium"/><![CDATA[ & ]]><xsl:value-of select="format-number(($medium div $total)*100,'0.0')"/><![CDATA[\% \\
Baja & ]]><xsl:value-of select="$low"/><![CDATA[ & ]]><xsl:value-of select="format-number(($low div $total)*100,'0.0')"/><![CDATA[\% \\
\hline
\textbf{Total} & \textbf{]]><xsl:value-of select="$total"/><![CDATA[} & \textbf{100\%} \\
\hline
\end{longtable}

\noindent
\textbf{Puntaje promedio CVSS:} ]]><xsl:value-of select="format-number($avg,'0.0')"/><![CDATA[ sobre 10.

\vspace{1cm}

\section*{Principales Vulnerabilidades Detectadas}
La siguiente tabla muestra las vulnerabilidades de mayor impacto, ordenadas por criticidad:

\begin{longtable}{|c|p{7cm}|c|p{5cm}|}
\hline
\rowcolor{gray20}
\# & \textbf{Vulnerabilidad} & \textbf{Severidad} & \textbf{Descripción Breve} \\
\hline
]]>
<xsl:for-each select="$results[number(*[local-name()='severity']) &gt;= 7][position() &lt;= 10]">
<xsl:sort select="number(*[local-name()='severity'])" data-type="number" order="descending"/>
<xsl:value-of select="position()"/><![CDATA[ & ]]>
<xsl:call-template name="escape-latex"><xsl:with-param name="text" select="*[local-name()='name']"/></xsl:call-template><![CDATA[ & ]]>
<xsl:value-of select="format-number(number(*[local-name()='severity']),'0.0')"/><![CDATA[ & ]]>
<xsl:call-template name="escape-latex"><xsl:with-param name="text" select="substring(*[local-name()='description'],1,120)"/></xsl:call-template><![CDATA[... \\
\hline
]]>
</xsl:for-each>
<![CDATA[
\end{longtable}

\section*{Recomendaciones Estratégicas}
\begin{itemize}
  \item Priorizar la mitigación de vulnerabilidades críticas y altas.
  \item Actualizar sistemas operativos, aplicaciones y librerías obsoletas.
  \item Implementar revisiones periódicas de configuración segura.
  \item Establecer monitoreo continuo de amenazas y escaneos mensuales.
\end{itemize}

\vspace{1cm}

\section*{Conclusión}
La aplicación de las medidas recomendadas reducirá la superficie de ataque y fortalecerá la postura
de seguridad de la organización, mitigando riesgos operativos y reputacionales.

\vfill
\begin{center}
\textbf{José Andrés Napoli} \\
Analista de Seguridad Informática \\
\vspace{0.5cm}
\textit{Confidencial – Uso Interno Únicamente}
\end{center}

\end{document}
]]>
  </xsl:template>
</xsl:stylesheet>

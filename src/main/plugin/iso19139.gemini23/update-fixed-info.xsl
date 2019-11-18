<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gss="http://www.isotc211.org/2005/gss"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:tr="java:org.fao.geonet.api.records.formatters.SchemaLocalizations"
                xmlns:java="java:org.fao.geonet.util.XslUtil"
                version="2.0" exclude-result-prefixes="#all">

  <xsl:import href="../iso19139/update-fixed-info.xsl"/>


  <!-- Override template to add gss namespace, to avoid being added to the elements inline.
       Used in templates and not defined in the template from iso19139
  -->
  <xsl:template name="add-namespaces">
    <xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
    <xsl:namespace name="gco" select="'http://www.isotc211.org/2005/gco'"/>
    <xsl:namespace name="gmd" select="'http://www.isotc211.org/2005/gmd'"/>
    <xsl:namespace name="srv" select="'http://www.isotc211.org/2005/srv'"/>
    <xsl:namespace name="gmx" select="'http://www.isotc211.org/2005/gmx'"/>
    <xsl:namespace name="gts" select="'http://www.isotc211.org/2005/gts'"/>
    <xsl:namespace name="gsr" select="'http://www.isotc211.org/2005/gsr'"/>
    <xsl:namespace name="gmi" select="'http://www.isotc211.org/2005/gmi'"/>
    <xsl:namespace name="gss" select="'http://www.isotc211.org/2005/gss'"/>
    <xsl:choose>
      <xsl:when test="$isUsing2005Schema and not($isUsing2007Schema)">
        <xsl:namespace name="gml" select="'http://www.opengis.net/gml'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:namespace name="gml" select="'http://www.opengis.net/gml/3.2'"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
  </xsl:template>

  <!-- remove empty gco:CharacterString child nodes that have been added by inflate-metadata -->

<!-- <xsl:template match="//*[@gco:nilReason]/gco:CharacterString">
        <xsl:choose>
            <xsl:when test="not(text())">
                <xsl:message>Empty</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Not Empty</xsl:message>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> -->



  <xsl:template match="gmd:LanguageCode[@codeListValue]" priority="10">

    <!-- Retrieve the translation for the codeListValue attribute -->
    <xsl:variable name="codelistTranslation"
                  select="tr:codelist-value-label(
                            tr:create('iso19139.gemini23'),
                            local-name(), @codeListValue)"/>

    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/">
      <xsl:apply-templates select="@*[name(.)!='codeList']"/>

      <xsl:value-of select="$codelistTranslation" />
    </gmd:LanguageCode>
  </xsl:template>

  <xsl:template match="//*[(@gco:nilReason='inapplicable' or @gco:nilReason='unknown')]/gco:CharacterString" priority="10">
    <xsl:choose>
      <xsl:when test="not(text())">
        <xsl:message>Empty: <xsl:value-of select="name()" /></xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Not Empty: <xsl:value-of select="name()" /></xsl:message>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

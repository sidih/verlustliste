<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="tei html teidocx xs"
   version="2.0">

   <xsl:import href="../../../../pub-XSLT/Stylesheets/html5-foundation6-chs/to.xsl"/>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p>TEI stylesheet for making HTML5 output (Zurb Foundation 6 http://foundation.zurb.com/sites/docs/).</p>
         <p>This software is dual-licensed:
            
            1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
            Unported License http://creativecommons.org/licenses/by-sa/3.0/ 
            
            2. http://www.opensource.org/licenses/BSD-2-Clause
            
            
            
            Redistribution and use in source and binary forms, with or without
            modification, are permitted provided that the following conditions are
            met:
            
            * Redistributions of source code must retain the above copyright
            notice, this list of conditions and the following disclaimer.
            
            * Redistributions in binary form must reproduce the above copyright
            notice, this list of conditions and the following disclaimer in the
            documentation and/or other materials provided with the distribution.
            
            This software is provided by the copyright holders and contributors
            "as is" and any express or implied warranties, including, but not
            limited to, the implied warranties of merchantability and fitness for
            a particular purpose are disclaimed. In no event shall the copyright
            holder or contributors be liable for any direct, indirect, incidental,
            special, exemplary, or consequential damages (including, but not
            limited to, procurement of substitute goods or services; loss of use,
            data, or profits; or business interruption) however caused and on any
            theory of liability, whether in contract, strict liability, or tort
            (including negligence or otherwise) arising in any way out of the use
            of this software, even if advised of the possibility of such damage.
         </p>
         <p>Andrej Pančur, Institute for Contemporary History</p>
         <p>Copyright: 2013, TEI Consortium</p>
      </desc>
   </doc>
   
   <xsl:param name="localWebsite">false</xsl:param>
   
   <!-- Uredi parametre v skladu z dodatnimi zahtevami za pretvorbo te publikacije: -->
   <!-- ../../../  -->
   <xsl:param name="path-general">https://www2.sistory.si/publikacije/</xsl:param>
   
   <!-- Iz datoteke ../../../../publikacije-XSLT/sistory/html5-foundation6-chs/to.xsl -->
   <xsl:param name="outputDir">docs/</xsl:param>
   
   <xsl:param name="homeLabel">SI-DIH</xsl:param>
   <xsl:param name="homeURL">https://github.com/sidih/verlustliste</xsl:param>
   
   <!-- Iz datoteke ../../../../publikacije-XSLT/sistory/html5-foundation6-chs/my-html_param.xsl -->
   <xsl:param name="title-bar-sticky">false</xsl:param>
   
   <xsl:param name="chapterAsSIstoryPublications">false</xsl:param>
   
   <!-- odstranim pri spodnjih param true -->
   <xsl:param name="numberFigures"></xsl:param>
   <xsl:param name="numberFrontTables"></xsl:param>
   <xsl:param name="numberHeadings"></xsl:param>
   <xsl:param name="numberParagraphs"></xsl:param>
   <xsl:param name="numberTables"></xsl:param>
   
   <!-- V html/head izpisani metapodatki -->
   <xsl:param name="description"></xsl:param>
   <xsl:param name="keywords"></xsl:param>
   <xsl:param name="title"></xsl:param>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
      <param name="thisLanguage"></param>
   </doc>
   <xsl:template name="divGen-main-content">
      <xsl:param name="thisLanguage"/>
      <!-- kolofon CIP -->
      <xsl:if test="self::tei:divGen[@type='cip']">
         <xsl:apply-templates select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc" mode="kolofon"/>
      </xsl:if>
      <!-- TEI kolofon -->
      <xsl:if test="self::tei:divGen[@type='teiHeader']">
         <xsl:apply-templates select="ancestor::tei:TEI/tei:teiHeader"/>
      </xsl:if>
      <!-- kazalo vsebine toc -->
      <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='toc'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='toc']">
         <xsl:call-template name="mainTOC"/>
      </xsl:if>
      <!-- kazalo slik -->
      <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='images'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='images']">
         <xsl:call-template name="images"/>
      </xsl:if>
      <!-- kazalo grafikonov -->
      <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='charts'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='charts']">
         <xsl:call-template name="charts"/>
      </xsl:if>
      <!-- kazalo tabel -->
      <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='tables'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='tables']">
         <xsl:call-template name="tables"/>
      </xsl:if>
      <!-- kazalo vsebine toc, ki izpiše samo glavne naslove poglavij, skupaj z imeni avtorjev poglavij -->
      <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='titleAuthor'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='titleAuthor']">
         <xsl:call-template name="TOC-title-author"/>
      </xsl:if>
      <!-- kazalo vsebine toc, ki izpiše samo naslove poglavij, kjer ima div atributa type in xml:id -->
      <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='titleType'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='titleType']">
         <xsl:call-template name="TOC-title-type"/>
      </xsl:if>
      <!-- toogle, ker sem spodaj dodal novo pretvorbo za persons -->
      <!-- seznam (indeks) oseb -->
      <!--<xsl:if test="self::tei:divGen[@type='index'][@xml:id='persons'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='persons']">
         <xsl:call-template name="persons"/>
      </xsl:if>-->
      <!-- seznam (indeks) krajev -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='places'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='places']">
         <xsl:call-template name="places"/>
      </xsl:if>
      <!-- seznam (indeks) organizacij -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='organizations'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='organizations']">
         <xsl:call-template name="organizations"/>
      </xsl:if>
      <!-- iskalnik -->
      <xsl:if test="self::tei:divGen[@type='search']">
         <xsl:call-template name="search"/>
      </xsl:if>
      <!-- DODAL SPODNJO SAMO ZA TO PRETVORBO! -->
      <!-- za generiranje datateble oseb -->
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='main']">
         <xsl:call-template name="datatables-main"/>
      </xsl:if>
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='residence']">
         <xsl:call-template name="datatables-residence"/>
      </xsl:if>
      s<xsl:if test="self::tei:divGen[@type='index'][@xml:id='event']">
         <xsl:call-template name="datatables-event"/>
      </xsl:if>
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='wounded']">
         <xsl:call-template name="datatables-wounded"/>
      </xsl:if>
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='pow']">
         <xsl:call-template name="datatables-pow"/>
      </xsl:if>
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='death']">
         <xsl:call-template name="datatables-death"/>
      </xsl:if>
      <xsl:if test="self::tei:divGen[@type='index'][@xml:id='all']">
         <xsl:call-template name="datatables-all"/>
      </xsl:if>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template name="datatables-main">
      <link rel="stylesheet" type="text/css" href="{if ($localWebsite='true') then 'datatables.min.css' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css'}" />
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables.min.js' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js'}"></script>
      
      <!-- ===== Dodatne resource datoteke ======================================= -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.responsive.min.js' else 'https://cdn.datatables.net/responsive/2.1.1/js/dataTables.responsive.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.buttons.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/dataTables.buttons.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.colVis.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/buttons.colVis.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.colReorder.min.js' else 'https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js'}"></script>
      
      <script type="text/javascript" src="{if ($localWebsite='true') then 'jszip.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'pdfmake.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'vfs_fonts.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.html5.min.js' else 'https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js'}"></script>
      <!-- določi, kje je naša dodatna DataTables js datoteka -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'range-filter-external-main.js' else 'range-filter-external-main.js'}"></script>
      
      <link href="{if ($localWebsite='true') then 'responsive.dataTables.min.css' else 'https://cdn.datatables.net/responsive/2.1.1/css/responsive.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <link href="{if ($localWebsite='true') then 'buttons.dataTables.min.css' else 'https://cdn.datatables.net/buttons/1.4.1/css/buttons.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <!-- ===== Dodatne resource datoteke ======================================= -->
      
      <style>
         *, *::after, *::before {
         box-sizing: border-box;
         }
         .pagination .current {
         background: #8e130b;
         }
      </style>
      
      <script>
         var columnIDs = [4];
      </script>
      <div class="table-scroll">
         <table id="datatableMain" class="display responsive nowrap targetTable" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Prepis</th>
                  <th>Priimek</th>
                  <th>Ime</th>
                  <th>Leto rojstva</th>
                  <th>Dežela</th>
                  <th>Faksimile</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th></th>
               </tr>
            </tfoot>
            <!--<tbody>-->
            <xsl:result-document href="docs/data-main.json" method="text" encoding="UTF-8">
               <xsl:text>{
  "data": [&#xA;</xsl:text>
               <xsl:for-each select="//tei:person[parent::tei:listPerson]">
                  <xsl:variable name="personID" select="@xml:id"/>
                  <xsl:text>[&#xA;</xsl:text>
                  
                  <!-- Prepis -->
                  <xsl:value-of select="concat('&quot;&lt;a href=\&quot;', ancestor::tei:div[@type='chapter']/@xml:id,'.html#',@xml:id,'\&quot; target=\&quot;_blank\&quot;&gt;','ID','&lt;/a&gt;&quot;')"/>
                  <xsl:text>,&#xA;</xsl:text>
                  
                  <!-- Priimek -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="surname"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Ime -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="forename"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Leto rojstva -->
                  <xsl:value-of select="concat('&quot;',tei:birth/tei:date,'&quot;')"/>
                  <xsl:text>,&#xA;</xsl:text>
                  
                  <!-- Dežela rojstva -->
                  <xsl:variable name="dezela">
                     <xsl:choose>
                        <xsl:when test="tei:birth/tei:placeName">
                           <xsl:value-of select="tei:birth/tei:placeName/tei:country"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="tei:birth/tei:country"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="dezela-slv">
                     <xsl:choose>
                        <xsl:when test="$dezela='Krain'">Kranjska</xsl:when>
                        <xsl:when test="$dezela='Istrien'">Istra</xsl:when>
                        <xsl:when test="$dezela='Kärnten'">Koroška</xsl:when>
                        <xsl:when test="$dezela='Küstenland'">Primorska</xsl:when>
                        <xsl:when test="$dezela='Steiermark'">Štajerska</xsl:when>
                        <xsl:otherwise>Goriška in Gradiščanska</xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:value-of select="concat('&quot;',$dezela-slv,'&quot;')"/>
                  <xsl:text>,&#xA;</xsl:text>
                  
                  <!-- Faksimile -->
                  <xsl:value-of select="concat('&quot;&lt;a href=\&quot;',@facs,'\&quot; target=\&quot;_blank\&quot;&gt;','ANNO','&lt;/a&gt;&quot;')"/>
                  <xsl:text>&#xA;</xsl:text>
                  
                  <xsl:text>]</xsl:text>
                  <xsl:if test="position() != last()">
                     <xsl:text>,
                     </xsl:text>
                  </xsl:if>
               </xsl:for-each>
               <xsl:text>]
}</xsl:text>
            </xsl:result-document>
            
            <!--</tbody>-->
         </table>
         <br/>
         <br/>
         <br/>
      </div>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template name="datatables-residence">
      <link rel="stylesheet" type="text/css" href="{if ($localWebsite='true') then 'datatables.min.css' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css'}" />
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables.min.js' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js'}"></script>
      
      <!-- ===== Dodatne resource datoteke ======================================= -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.responsive.min.js' else 'https://cdn.datatables.net/responsive/2.1.1/js/dataTables.responsive.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.buttons.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/dataTables.buttons.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.colVis.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/buttons.colVis.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.colReorder.min.js' else 'https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js'}"></script>
      
      <script type="text/javascript" src="{if ($localWebsite='true') then 'jszip.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'pdfmake.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'vfs_fonts.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.html5.min.js' else 'https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js'}"></script>
      <!-- določi, kje je naša dodatna DataTables js datoteka -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'range-filter-external-residence.js' else 'range-filter-external-residence.js'}"></script>
      
      <link href="{if ($localWebsite='true') then 'responsive.dataTables.min.css' else 'https://cdn.datatables.net/responsive/2.1.1/css/responsive.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <link href="{if ($localWebsite='true') then 'buttons.dataTables.min.css' else 'https://cdn.datatables.net/buttons/1.4.1/css/buttons.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <!-- ===== Dodatne resource datoteke ======================================= -->
      
      <style>
         *, *::after, *::before {
         box-sizing: border-box;
         }
         .pagination .current {
         background: #8e130b;
         }
      </style>
      
      <script>
         var columnIDs = [3, 4];
      </script>
      
      <div class="table-scroll">
         <table id="datatableResidence" class="display responsive nowrap targetTable" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Prepis</th>
                  <th>Priimek</th>
                  <th>Ime</th>
                  <th>Dežela</th>
                  <th>Okraj</th>
                  <th>Občina / Kraj</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
               </tr>
            </tfoot>
            <!--<tbody>-->
            <xsl:result-document href="docs/data-residence.json" method="text" encoding="UTF-8">
               <xsl:text>{
  "data": [&#xA;</xsl:text>
               <xsl:for-each select="//tei:person[parent::tei:listPerson]">
                  <xsl:variable name="personID" select="@xml:id"/>
                  <xsl:text>[&#xA;</xsl:text>
                  
                  <!-- Prepis -->
                  <xsl:value-of select="concat('&quot;&lt;a href=\&quot;', ancestor::tei:div[@type='chapter']/@xml:id,'.html#',@xml:id,'\&quot; target=\&quot;_blank\&quot;&gt;','ID','&lt;/a&gt;&quot;')"/>
                  <xsl:text>,&#xA;</xsl:text>
                  
                  <!-- Priimek -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="surname"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Ime -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="forename"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Dežela rojstva -->
                  <xsl:variable name="dezela">
                     <xsl:choose>
                        <xsl:when test="tei:birth/tei:placeName">
                           <xsl:value-of select="tei:birth/tei:placeName/tei:country"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="tei:birth/tei:country"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="dezela-slv">
                     <xsl:choose>
                        <xsl:when test="$dezela='Krain'">Kranjska</xsl:when>
                        <xsl:when test="$dezela='Istrien'">Istra</xsl:when>
                        <xsl:when test="$dezela='Kärnten'">Koroška</xsl:when>
                        <xsl:when test="$dezela='Küstenland'">Primorska</xsl:when>
                        <xsl:when test="$dezela='Steiermark'">Štajerska</xsl:when>
                        <xsl:otherwise>Goriška in Gradiščanska</xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:value-of select="concat('&quot;',$dezela-slv,'&quot;')"/>
                  <xsl:text>,&#xA;</xsl:text>
                  
                  <!-- Okraj rojstva -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:choose>
                     <xsl:when test="tei:birth/tei:placeName">
                        <xsl:for-each select="tei:birth/tei:placeName/tei:region[not(@type='municipality')]">
                           <xsl:value-of select="."/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:for-each select="tei:birth/tei:region">
                           <xsl:value-of select="."/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Občina / Kraj rojstva -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:birth/tei:placeName/tei:region[@type='municipality'] | tei:birth/tei:placeName/tei:settlement | tei:birth/tei:settlement">
                     <xsl:value-of select="."/>
                     <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:text>&quot;</xsl:text>
                  <xsl:text>&#xA;</xsl:text>
                  
                  <xsl:text>]</xsl:text>
                  <xsl:if test="position() != last()">
                     <xsl:text>,
                     </xsl:text>
                  </xsl:if>
               </xsl:for-each>
               <xsl:text>]
}</xsl:text>
            </xsl:result-document>
            
            <!--</tbody>-->
         </table>
         <br/>
         <br/>
         <br/>
      </div>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template name="datatables-event">
      <link rel="stylesheet" type="text/css" href="{if ($localWebsite='true') then 'datatables.min.css' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css'}" />
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables.min.js' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js'}"></script>
      
      <!-- ===== Dodatne resource datoteke ======================================= -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.responsive.min.js' else 'https://cdn.datatables.net/responsive/2.1.1/js/dataTables.responsive.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.buttons.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/dataTables.buttons.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.colVis.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/buttons.colVis.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.colReorder.min.js' else 'https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js'}"></script>
      
      <script type="text/javascript" src="{if ($localWebsite='true') then 'jszip.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'pdfmake.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'vfs_fonts.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.html5.min.js' else 'https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js'}"></script>
      <!-- določi, kje je naša dodatna DataTables js datoteka -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'range-filter-external-event.js' else 'range-filter-external-event.js'}"></script>
      
      <link href="{if ($localWebsite='true') then 'responsive.dataTables.min.css' else 'https://cdn.datatables.net/responsive/2.1.1/css/responsive.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <link href="{if ($localWebsite='true') then 'buttons.dataTables.min.css' else 'https://cdn.datatables.net/buttons/1.4.1/css/buttons.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <!-- ===== Dodatne resource datoteke ======================================= -->
      
      <style>
         *, *::after, *::before {
         box-sizing: border-box;
         }
         .pagination .current {
         background: #8e130b;
         }
      </style>
      
      <script>
         var columnIDs = [5];
      </script>
      
      <div class="table-scroll">
         <table id="datatableEvent" class="display responsive nowrap targetTable" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Prepis</th>
                  <th>Priimek</th>
                  <th>Ime</th>
                  <th>Položaj</th>
                  <th>Enota</th>
                  <th>Usoda</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><select class="filterSelect"><option value="">Prikaži vse</option></select></th>
               </tr>
            </tfoot>
            <!--<tbody>-->
            <xsl:result-document href="docs/data-event.json" method="text" encoding="UTF-8">
               <xsl:text>{
  "data": [&#xA;</xsl:text>
               <xsl:for-each select="//tei:person[parent::tei:listPerson]">
                  <xsl:variable name="personID" select="@xml:id"/>
                  <xsl:text>[&#xA;</xsl:text>
                  
                  <!-- Prepis -->
                  <xsl:value-of select="concat('&quot;&lt;a href=\&quot;', ancestor::tei:div[@type='chapter']/@xml:id,'.html#',@xml:id,'\&quot; target=\&quot;_blank\&quot;&gt;','ID','&lt;/a&gt;&quot;')"/>
                  <xsl:text>,&#xA;</xsl:text>
                  
                  <!-- Priimek -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="surname"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Ime -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="forename"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Položaj -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:choose>
                     <xsl:when test="tei:socecStatus[@type]">
                        <xsl:for-each select="tei:socecStatus[@type='true']">
                           <xsl:value-of select="normalize-space(.)"/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:for-each select="tei:socecStatus">
                           <xsl:value-of select="normalize-space(.)"/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Enota -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:choose>
                     <xsl:when test="tei:affiliation[@type]">
                        <xsl:for-each select="tei:affiliation[@type='true']">
                           <xsl:value-of select="normalize-space(.)"/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:for-each select="tei:affiliation">
                           <xsl:value-of select="normalize-space(translate(.,'&quot;',''))"/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Dogodek/Usoda [@type= ('wounded','pow','death')] -->
                  <xsl:variable name="dogodki">
                     <xsl:for-each select="tei:event[@type= ('wounded','pow','death')]">
                        <dogodek>
                           <xsl:choose>
                              <xsl:when test="@type='wounded'">ranjen</xsl:when>
                              <xsl:when test="@type='pow'">ujet</xsl:when>
                              <xsl:when test="@type='death'">umrl</xsl:when>
                           </xsl:choose>
                        </dogodek>
                     </xsl:for-each>
                  </xsl:variable>
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="$dogodki/html:dogodek">
                     <xsl:value-of select="."/>
                     <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:text>&quot;</xsl:text>
                  <xsl:text>&#xA;</xsl:text>
                  
                  <xsl:text>]</xsl:text>
                  <xsl:if test="position() != last()">
                     <xsl:text>,
                     </xsl:text>
                  </xsl:if>
               </xsl:for-each>
               <xsl:text>]
}</xsl:text>
            </xsl:result-document>
            
            <!--</tbody>-->
         </table>
         <br/>
         <br/>
         <br/>
      </div>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template name="datatables-wounded">
      <link rel="stylesheet" type="text/css" href="{if ($localWebsite='true') then 'datatables.min.css' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css'}" />
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables.min.js' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js'}"></script>
      
      <!-- ===== Dodatne resource datoteke ======================================= -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.responsive.min.js' else 'https://cdn.datatables.net/responsive/2.1.1/js/dataTables.responsive.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.buttons.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/dataTables.buttons.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.colVis.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/buttons.colVis.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.colReorder.min.js' else 'https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js'}"></script>
      
      <script type="text/javascript" src="{if ($localWebsite='true') then 'jszip.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'pdfmake.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'vfs_fonts.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.html5.min.js' else 'https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js'}"></script>
      <!-- določi, kje je naša dodatna DataTables js datoteka -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'range-filter-external-wounded.js' else 'range-filter-external-wounded.js'}"></script>
      
      <link href="{if ($localWebsite='true') then 'responsive.dataTables.min.css' else 'https://cdn.datatables.net/responsive/2.1.1/css/responsive.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <link href="{if ($localWebsite='true') then 'buttons.dataTables.min.css' else 'https://cdn.datatables.net/buttons/1.4.1/css/buttons.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <!-- ===== Dodatne resource datoteke ======================================= -->
      
      <style>
         *, *::after, *::before {
         box-sizing: border-box;
         }
         .pagination .current {
         background: #8e130b;
         }
      </style>
      
      <script>
         var columnIDs = [];
      </script>
      
      <div class="table-scroll">
         <table id="datatableWounded" class="display responsive nowrap targetTable" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Prepis</th>
                  <th>Priimek</th>
                  <th>Ime</th>
                  <th>Datum</th>
                  <th>Celoten opis</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
               </tr>
            </tfoot>
            <!--<tbody>-->
            <xsl:result-document href="docs/data-wounded.json" method="text" encoding="UTF-8">
               <xsl:text>{
  "data": [&#xA;</xsl:text>
               <xsl:for-each select="//tei:person[parent::tei:listPerson][tei:event/@type='wounded']">
                  <xsl:variable name="personID" select="@xml:id"/>
                  <xsl:text>[&#xA;</xsl:text>
                  
                  <!-- Prepis -->
                  <xsl:value-of select="concat('&quot;&lt;a href=\&quot;', ancestor::tei:div[@type='chapter']/@xml:id,'.html#',@xml:id,'\&quot; target=\&quot;_blank\&quot;&gt;','ID','&lt;/a&gt;&quot;')"/>
                  <xsl:text>,&#xA;</xsl:text>
                  
                  <!-- Priimek -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="surname"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Ime -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="forename"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- datum -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:event[@type='wounded'][position()=last()]">
                     <xsl:value-of select="normalize-space(tei:desc/tei:date)"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Opis -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:event[@type='wounded'][position()=last()]">
                     <xsl:value-of select="normalize-space(.)"/>
                  </xsl:for-each>
                  <xsl:text>&quot;</xsl:text>
                  <xsl:text>&#xA;</xsl:text>
                  
                  <xsl:text>]</xsl:text>
                  <xsl:if test="position() != last()">
                     <xsl:text>,
                     </xsl:text>
                  </xsl:if>
               </xsl:for-each>
               <xsl:text>]
}</xsl:text>
            </xsl:result-document>
            
            <!--</tbody>-->
         </table>
         <br/>
         <br/>
         <br/>
      </div>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template name="datatables-pow">
      <link rel="stylesheet" type="text/css" href="{if ($localWebsite='true') then 'datatables.min.css' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css'}" />
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables.min.js' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js'}"></script>
      
      <!-- ===== Dodatne resource datoteke ======================================= -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.responsive.min.js' else 'https://cdn.datatables.net/responsive/2.1.1/js/dataTables.responsive.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.buttons.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/dataTables.buttons.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.colVis.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/buttons.colVis.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.colReorder.min.js' else 'https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js'}"></script>
      
      <script type="text/javascript" src="{if ($localWebsite='true') then 'jszip.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'pdfmake.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'vfs_fonts.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.html5.min.js' else 'https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js'}"></script>
      <!-- določi, kje je naša dodatna DataTables js datoteka -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'range-filter-external-pow.js' else 'range-filter-external-pow.js'}"></script>
      
      <link href="{if ($localWebsite='true') then 'responsive.dataTables.min.css' else 'https://cdn.datatables.net/responsive/2.1.1/css/responsive.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <link href="{if ($localWebsite='true') then 'buttons.dataTables.min.css' else 'https://cdn.datatables.net/buttons/1.4.1/css/buttons.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <!-- ===== Dodatne resource datoteke ======================================= -->
      
      <style>
         *, *::after, *::before {
         box-sizing: border-box;
         }
         .pagination .current {
         background: #8e130b;
         }
      </style>
      
      <script>
         var columnIDs = [];
      </script>
      
      <div class="table-scroll">
         <table id="datatablePow" class="display responsive nowrap targetTable" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Prepis</th>
                  <th>Priimek</th>
                  <th>Ime</th>
                  <th>Datum</th>
                  <th>Celoten opis</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
               </tr>
            </tfoot>
            <!--<tbody>-->
            <xsl:result-document href="docs/data-pow.json" method="text" encoding="UTF-8">
               <xsl:text>{
  "data": [&#xA;</xsl:text>
               <xsl:for-each select="//tei:person[parent::tei:listPerson][tei:event/@type='pow']">
                  <xsl:variable name="personID" select="@xml:id"/>
                  <xsl:text>[&#xA;</xsl:text>
                  
                  <!-- Prepis -->
                  <xsl:value-of select="concat('&quot;&lt;a href=\&quot;', ancestor::tei:div[@type='chapter']/@xml:id,'.html#',@xml:id,'\&quot; target=\&quot;_blank\&quot;&gt;','ID','&lt;/a&gt;&quot;')"/>
                  <xsl:text>,&#xA;</xsl:text>
                  
                  <!-- Priimek -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="surname"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Ime -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="forename"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- datum -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:event[@type='pow']">
                     <xsl:value-of select="normalize-space(tei:desc/tei:date)"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Opis -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:event[@type='pow']">
                     <xsl:value-of select="normalize-space(tei:desc[position()=last()])"/>
                  </xsl:for-each>
                  <xsl:text>&quot;</xsl:text>
                  <xsl:text>&#xA;</xsl:text>
                  
                  
                  <xsl:text>]</xsl:text>
                  <xsl:if test="position() != last()">
                     <xsl:text>,
                     </xsl:text>
                  </xsl:if>
               </xsl:for-each>
               <xsl:text>]
}</xsl:text>
            </xsl:result-document>
            
            <!--</tbody>-->
         </table>
         <br/>
         <br/>
         <br/>
      </div>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template name="datatables-death">
      <link rel="stylesheet" type="text/css" href="{if ($localWebsite='true') then 'datatables.min.css' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css'}" />
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables.min.js' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js'}"></script>
      
      <!-- ===== Dodatne resource datoteke ======================================= -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.responsive.min.js' else 'https://cdn.datatables.net/responsive/2.1.1/js/dataTables.responsive.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.buttons.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/dataTables.buttons.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.colVis.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/buttons.colVis.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.colReorder.min.js' else 'https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js'}"></script>
      
      <script type="text/javascript" src="{if ($localWebsite='true') then 'jszip.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'pdfmake.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'vfs_fonts.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.html5.min.js' else 'https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js'}"></script>
      <!-- določi, kje je naša dodatna DataTables js datoteka -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'range-filter-external-death.js' else 'range-filter-external-death.js'}"></script>
      
      <link href="{if ($localWebsite='true') then 'responsive.dataTables.min.css' else 'https://cdn.datatables.net/responsive/2.1.1/css/responsive.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <link href="{if ($localWebsite='true') then 'buttons.dataTables.min.css' else 'https://cdn.datatables.net/buttons/1.4.1/css/buttons.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <!-- ===== Dodatne resource datoteke ======================================= -->
      
      <style>
         *, *::after, *::before {
         box-sizing: border-box;
         }
         .pagination .current {
         background: #8e130b;
         }
      </style>
      
      <script>
         var columnIDs = [];
      </script>
      
      <div class="table-scroll">
         <table id="datatableDeath" class="display responsive nowrap targetTable" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Prepis</th>
                  <th>Priimek</th>
                  <th>Ime</th>
                  <th>Datum</th>
                  <th>Celoten opis</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
               </tr>
            </tfoot>
            <!--<tbody>-->
            <xsl:result-document href="docs/data-death.json" method="text" encoding="UTF-8">
               <xsl:text>{
  "data": [&#xA;</xsl:text>
               <xsl:for-each select="//tei:person[parent::tei:listPerson][tei:event/@type='death']">
                  <xsl:variable name="personID" select="@xml:id"/>
                  <xsl:text>[&#xA;</xsl:text>
                  
                  <!-- Prepis -->
                  <xsl:value-of select="concat('&quot;&lt;a href=\&quot;', ancestor::tei:div[@type='chapter']/@xml:id,'.html#',@xml:id,'\&quot; target=\&quot;_blank\&quot;&gt;','ID','&lt;/a&gt;&quot;')"/>
                  <xsl:text>,&#xA;</xsl:text>
                  
                  <!-- Priimek -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="surname"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Ime -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="forename"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- datum -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:event[@type='death']">
                     <xsl:value-of select="normalize-space(tei:desc/tei:date[1])"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Opis -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:event[@type='death']">
                     <xsl:value-of select="normalize-space(tei:desc[1])"/>
                  </xsl:for-each>
                  <xsl:text>&quot;</xsl:text>
                  <xsl:text>&#xA;</xsl:text>
                  
                  <xsl:text>]</xsl:text>
                  <xsl:if test="position() != last()">
                     <xsl:text>,
                     </xsl:text>
                  </xsl:if>
               </xsl:for-each>
               <xsl:text>]
}</xsl:text>
            </xsl:result-document>
            
            <!--</tbody>-->
         </table>
         <br/>
         <br/>
         <br/>
      </div>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template name="datatables-all">
      <link rel="stylesheet" type="text/css" href="{if ($localWebsite='true') then 'datatables.min.css' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.css'}" />
      <script type="text/javascript" src="{if ($localWebsite='true') then 'datatables.min.js' else 'https://cdn.datatables.net/v/zf/dt-1.10.13/cr-1.3.2/datatables.min.js'}"></script>
      
      <!-- ===== Dodatne resource datoteke ======================================= -->
      <!--<script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.responsive.min.js' else 'https://cdn.datatables.net/responsive/2.1.1/js/dataTables.responsive.min.js'}"></script>-->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.buttons.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/dataTables.buttons.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.colVis.min.js' else 'https://cdn.datatables.net/buttons/1.4.1/js/buttons.colVis.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'dataTables.colReorder.min.js' else 'https://cdn.datatables.net/colreorder/1.3.3/js/dataTables.colReorder.min.js'}"></script>
      
      <script type="text/javascript" src="{if ($localWebsite='true') then 'jszip.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'pdfmake.min.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'vfs_fonts.js' else 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js'}"></script>
      <script type="text/javascript" src="{if ($localWebsite='true') then 'buttons.html5.min.js' else 'https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js'}"></script>
      <!-- določi, kje je naša dodatna DataTables js datoteka -->
      <script type="text/javascript" src="{if ($localWebsite='true') then 'range-filter-external-all.js' else 'range-filter-external-all.js'}"></script>
      
      <link href="{if ($localWebsite='true') then 'responsive.dataTables.min.css' else 'https://cdn.datatables.net/responsive/2.1.1/css/responsive.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <link href="{if ($localWebsite='true') then 'buttons.dataTables.min.css' else 'https://cdn.datatables.net/buttons/1.4.1/css/buttons.dataTables.min.css'}" rel="stylesheet" type="text/css" />
      <!-- ===== Dodatne resource datoteke ======================================= -->
      
      <style>
         *, *::after, *::before {
         box-sizing: border-box;
         }
         .pagination .current {
         background: #8e130b;
         }
      </style>
      
      <script>
         var columnIDs = [];
      </script>
      
      <div>
         <table id="datatablePersons" class="display responsive nowrap targetTable" width="100%" cellspacing="0">
            <thead>
               <tr>
                  <th>Priimek</th>
                  <th>Ime</th>
                  <th>Rojstvo</th>
                  <th>Dežela</th>
                  <th>Okraj</th>
                  <th>Občina / Kraj</th>
                  <th>Dogodek</th>
                  <th>Položaj</th>
                  <th>Enota</th>
                  <th>Prepis</th>
                  <th>Faksimile</th>
               </tr>
            </thead>
            <tfoot>
               <tr>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th><input class="filterInputText" placeholder="Iskanje" type="text"/></th>
                  <th></th>
                  <th></th>
               </tr>
            </tfoot>
            <!--<tbody>-->
            <xsl:result-document href="docs/data-all.json" method="text" encoding="UTF-8">
               <xsl:text>{
  "data": [&#xA;</xsl:text>
               <xsl:for-each select="//tei:person[parent::tei:listPerson]">
                  <xsl:variable name="personID" select="@xml:id"/>
                  <xsl:text>[&#xA;</xsl:text>
                  
                  <!-- Priimek -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="surname"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Ime -->
                  <!-- Vedno samo prvi persName, ker je možen tudi drugi persName[@type='father']  -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:persName[1]">
                     <xsl:call-template name="forename"/>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Leto rojstva -->
                  <xsl:value-of select="concat('&quot;',tei:birth/tei:date,'&quot;')"/>
                  <xsl:text>,&#xA;</xsl:text>
                  
                  <!-- Dežela rojstva -->
                  <xsl:variable name="dezela">
                     <xsl:choose>
                        <xsl:when test="tei:birth/tei:placeName">
                           <xsl:value-of select="tei:birth/tei:placeName/tei:country"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="tei:birth/tei:country"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="dezela-slv">
                     <xsl:choose>
                        <xsl:when test="$dezela='Krain'">Kranjska</xsl:when>
                        <xsl:when test="$dezela='Istrien'">Istra</xsl:when>
                        <xsl:when test="$dezela='Kärnten'">Koroška</xsl:when>
                        <xsl:when test="$dezela='Küstenland'">Primorska</xsl:when>
                        <xsl:when test="$dezela='Steiermark'">Štajerska</xsl:when>
                        <xsl:otherwise>Goriška in Gradiščanska</xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:value-of select="concat('&quot;',$dezela-slv,'&quot;')"/>
                  <xsl:text>,&#xA;</xsl:text>
                  
                  <!-- Okraj rojstva -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:choose>
                     <xsl:when test="tei:birth/tei:placeName">
                        <xsl:for-each select="tei:birth/tei:placeName/tei:region[not(@type='municipality')]">
                           <xsl:value-of select="."/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:for-each select="tei:birth/tei:region">
                           <xsl:value-of select="."/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Občina / Kraj rojstva -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="tei:birth/tei:placeName/tei:region[@type='municipality'] | tei:birth/tei:placeName/tei:settlement | tei:birth/tei:settlement">
                     <xsl:value-of select="."/>
                     <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Dogodek [@type= ('wounded','pow','death')] -->
                  <xsl:variable name="dogodki">
                     <xsl:for-each select="tei:event[@type= ('wounded','pow','death')]">
                        <dogodek>
                           <xsl:choose>
                              <xsl:when test="@type='wounded'">ranjen</xsl:when>
                              <xsl:when test="@type='pow'">ujet</xsl:when>
                              <xsl:when test="@type='death'">umrl</xsl:when>
                           </xsl:choose>
                        </dogodek>
                     </xsl:for-each>
                  </xsl:variable>
                  <xsl:text>&quot;</xsl:text>
                  <xsl:for-each select="$dogodki/html:dogodek">
                     <xsl:value-of select="."/>
                     <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Položaj -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:choose>
                     <xsl:when test="tei:socecStatus[@type]">
                        <xsl:for-each select="tei:socecStatus[@type='true']">
                           <xsl:value-of select="normalize-space(.)"/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:for-each select="tei:socecStatus">
                           <xsl:value-of select="normalize-space(.)"/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Enota -->
                  <xsl:text>&quot;</xsl:text>
                  <xsl:choose>
                     <xsl:when test="tei:affiliation[@type]">
                        <xsl:for-each select="tei:affiliation[@type='true']">
                           <xsl:value-of select="normalize-space(.)"/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:for-each select="tei:affiliation">
                           <xsl:value-of select="normalize-space(translate(.,'&quot;',''))"/>
                           <xsl:if test="position() != last()">
                              <xsl:text>, </xsl:text>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text>&quot;,&#xA;</xsl:text>
                  
                  <!-- Dvojnik (sameAs) -->
                  
                  <!-- Prepis -->
                  <xsl:value-of select="concat('&quot;&lt;a href=\&quot;', ancestor::tei:div[@type='chapter']/@xml:id,'.html#',@xml:id,'\&quot; target=\&quot;_blank\&quot;&gt;','ID','&lt;/a&gt;&quot;')"/>
                  <xsl:text>,&#xA;</xsl:text>
                  
                  <!-- Faksimile -->
                  <xsl:value-of select="concat('&quot;&lt;a href=\&quot;',@facs,'\&quot; target=\&quot;_blank\&quot;&gt;','ANNO','&lt;/a&gt;&quot;')"/>
                  <xsl:text>&#xA;</xsl:text>
                  
                  <xsl:text>]</xsl:text>
                  <xsl:if test="position() != last()">
                     <xsl:text>,
                     </xsl:text>
                  </xsl:if>
               </xsl:for-each>
               <xsl:text>]
}</xsl:text>
            </xsl:result-document>
               
            <!--</tbody>-->
         </table>
         <br/>
         <br/>
         <br/>
      </div>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template name="surname">
      <xsl:choose>
         <xsl:when test="tei:surname[@type]">
            <xsl:for-each select="tei:surname[@type='true']">
               <xsl:value-of select="."/>
               <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
               </xsl:if>
            </xsl:for-each>
            <xsl:if test="tei:addName[@type]">
               <xsl:text> recte </xsl:text>
               <xsl:value-of select="tei:addName[@type='true']"/>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:for-each select="tei:surname">
               <xsl:value-of select="."/>
               <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
               </xsl:if>
            </xsl:for-each>
            <xsl:if test="tei:addName">
               <xsl:text> recte </xsl:text>
               <xsl:value-of select="tei:addName"/>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template name="forename">
      <xsl:choose>
         <xsl:when test="tei:surname[@type]">
            <xsl:for-each select="tei:forename[@type='true']">
               <xsl:value-of select="."/>
               <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
               </xsl:if>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:for-each select="tei:forename">
               <xsl:value-of select="."/>
               <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
               </xsl:if>
            </xsl:for-each>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Sezname oseb procesiram na nov način</desc>
   </doc>
   <xsl:template match="tei:listPerson">
      <xsl:apply-templates/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template match="tei:person">
      <p id="{@xml:id}">
         <xsl:for-each select="tei:persName[1]">
            <xsl:for-each select="tei:*">
               <xsl:value-of select="."/>
               <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
               </xsl:if>
            </xsl:for-each>
         </xsl:for-each>
         <xsl:if test="tei:persName[2]">
            <xsl:text> </xsl:text>
            <xsl:value-of select="tei:note[following-sibling::tei:persName[1]]"/>
            <xsl:text> </xsl:text>
            <xsl:for-each select="tei:persName[2]">
               <xsl:for-each select="tei:*">
                  <xsl:value-of select="."/>
                  <xsl:if test="position() != last()">
                     <xsl:text> </xsl:text>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:if>
         <xsl:text>, </xsl:text>
         <xsl:value-of select="tei:socecStatus[1]"/>
         <xsl:if test="tei:socecStatus[2]">
            <xsl:text> </xsl:text>
            <xsl:value-of select="tei:note[following-sibling::*[1][xs:string(node-name(.))='socecStatus']]"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="tei:socecStatus[2]"/>
         </xsl:if>
         <xsl:text>, </xsl:text>
         <xsl:for-each select="tei:affiliation | tei:note[following-sibling::*[1][xs:string(node-name(.))='affiliation']]">
            <xsl:value-of select="."/>
            <xsl:choose>
               <xsl:when test=" position() = 3 and self::*[xs:string(node-name(.))='affiliation'] and following-sibling::*[1][xs:string(node-name(.))='affiliation']">
                  <xsl:text>, </xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:if test="position() != last()">
                     <xsl:text> </xsl:text>
                  </xsl:if>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
         <xsl:text>, </xsl:text>
         <xsl:for-each select="tei:birth">
            <xsl:choose>
               <xsl:when test="tei:placeName">
                  <xsl:for-each select="tei:placeName/*">
                     <xsl:value-of select="."/>
                     <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="tei:date">
                     <xsl:text>, </xsl:text>
                     <xsl:value-of select="tei:date"/>
                  </xsl:if>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:for-each select="*">
                     <xsl:value-of select="."/>
                     <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
         <xsl:text>; </xsl:text>
         <xsl:for-each select="tei:event">
            <xsl:for-each select="*">
               <xsl:value-of select="."/>
               <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
               </xsl:if>
            </xsl:for-each>
            <xsl:if test="position() != last()">
               <xsl:text> </xsl:text>
            </xsl:if>
         </xsl:for-each>
         
         <xsl:text> [</xsl:text>
         <a href="{@facs}" target="_blank">Faksimile</a>
         <xsl:text>] [</xsl:text>
         <a href="{concat('person/',@xml:id,'.html')}" target="_blank">Kodirani podatki</a>
         <xsl:text>]</xsl:text>
         
         <xsl:call-template name="person-page"/>
         
      </p>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>dopolnim iskalnik, tako da procesira tudi //tei:div[@type='chapter']/tei:listPerson/tei:person kot samostojne enote</desc>
   </doc>
   <xsl:template name="search">
      <xsl:variable name="tei-id" select="ancestor::tei:TEI/@xml:id"/>
      <xsl:variable name="sistoryAbsolutePath">
         <xsl:if test="$chapterAsSIstoryPublications='true'">http://www.sistory.si</xsl:if>
      </xsl:variable>
      <div id="tipue_search_content">
         <xsl:text></xsl:text>
         <xsl:variable name="datoteka-js" select="concat($outputDir,ancestor::tei:TEI/@xml:id,'/','tipuesearch_content.js')"/>
         <xsl:result-document href="{$datoteka-js}" method="text" encoding="UTF-8">
            <!-- ZAČETEK JavaScript dokumenta -->
            <xsl:text>var tipuesearch = {"pages": [
                                    </xsl:text>
            
            <!-- procesira samo tei:div[@type='chapter']/tei:listPerson -->
            <xsl:for-each select="//tei:div[@type='chapter']/tei:listPerson/tei:person">
               <xsl:variable name="generatedLink">
                  <xsl:apply-templates mode="generateLink" select="."/>
               </xsl:variable>
               <xsl:variable name="oseba-naziv">
                  <xsl:call-template name="oseba-naziv"/>
               </xsl:variable>
               <xsl:variable name="besedilo">
                  <xsl:apply-templates mode="besedilo"/>
               </xsl:variable>
               <xsl:text>{ "title": "</xsl:text>
               <xsl:value-of select="normalize-space(translate(translate($oseba-naziv,'&#xA;',' '),'&quot;',''))"/>
               <xsl:text>", "text": "</xsl:text>
               <xsl:value-of select="normalize-space(translate($besedilo,'&#xA;&quot;','&#x20;'))"/>
               <xsl:text>", "tags": "</xsl:text>
               <xsl:text>", "url": "</xsl:text>
               <xsl:value-of select="concat($sistoryAbsolutePath,$generatedLink)"/>
               <xsl:text>" }</xsl:text>
               <xsl:if test="position() != last()">
                  <xsl:text>,</xsl:text>
               </xsl:if>
               
               <xsl:text>&#xA;</xsl:text>
            </xsl:for-each>
            
            <!-- KONEC JavaScript dokumenta -->
            <xsl:text>
                     ]};
                </xsl:text>
         </xsl:result-document>
      </div>
      
      <!-- JavaScript, s katerim se požene iskanje -->
      <xsl:text disable-output-escaping="yes"><![CDATA[<script>
       $(document).ready(function() {
          $('#tipue_search_input').tipuesearch({
          'show': 10,
          'descriptiveWords': 250,
          'wholeWords': false
        });
      });
</script>]]></xsl:text>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Ime osebe za iskalnik</desc>
   </doc>
   <xsl:template name="oseba-naziv">
      <xsl:for-each select="tei:persName[1]">
         <xsl:for-each select="tei:*">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()">
               <xsl:text> </xsl:text>
            </xsl:if>
         </xsl:for-each>
      </xsl:for-each>
      <xsl:if test="tei:persName[2]">
         <xsl:text> </xsl:text>
         <xsl:value-of select="tei:note[following-sibling::tei:persName[1]]"/>
         <xsl:text> </xsl:text>
         <xsl:for-each select="tei:persName[2]">
            <xsl:for-each select="tei:*">
               <xsl:value-of select="."/>
               <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
               </xsl:if>
            </xsl:for-each>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template name="person-page">
      <xsl:variable name="datoteka" select="concat($outputDir,'person/',@xml:id,'.html')"/>
      <xsl:result-document href="{$datoteka}" doctype-system="" omit-xml-declaration="yes">
         <!-- vključimo HTML5 deklaracijo, skupaj z kodo za delovanje starejših verzij Internet Explorerja -->
         <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
         <html>
            <xsl:call-template name="addLangAtt"/>
            <!-- vključimo statični head -->
            <xsl:variable name="pagetitle">
               <xsl:call-template name="oseba-naziv"/>
            </xsl:variable>
            <xsl:sequence select="tei:htmlHead($pagetitle, 2)"/>
            <!-- začetek body -->
            <body id="TOP">
               <xsl:call-template name="bodyMicroData"/>
               <xsl:call-template name="bodyJavascriptHook">
                  <xsl:with-param name="thisLanguage"  select="@xml:lang"/>
               </xsl:call-template>
               <xsl:call-template name="bodyHook"/>
               <!-- začetek vsebine -->
               <div class="column row">
                  <!-- GLAVNA VSEBINA -->
                  <section>
                     <div class="row">
                        <div class="medium-2 columns show-for-medium">
                           <!--<xsl:call-template name="previous-divGen-Link">
                              <xsl:with-param name="thisDivGenType" select="@type"/>
                              <xsl:with-param name="thisLanguage" select="@xml:lang"/>
                           </xsl:call-template>-->
                        </div>
                        <div class="medium-8 small-12 columns">
                           <h2>
                              <xsl:call-template name="oseba-naziv"/>
                           </h2>
                        </div>
                        <div class="medium-2 columns show-for-medium text-right">
                           <!--<xsl:call-template name="next-divGen-Link">
                              <xsl:with-param name="thisDivGenType" select="@type"/>
                              <xsl:with-param name="thisLanguage" select="@xml:lang"/>
                           </xsl:call-template>-->
                        </div>
                     </div>
                     <div class="row hide-for-medium">
                        <div class="small-6 columns text-center">
                           <!--<xsl:call-template name="previous-divGen-Link">
                              <xsl:with-param name="thisDivGenType" select="@type"/>
                              <xsl:with-param name="thisLanguage" select="@xml:lang"/>
                           </xsl:call-template>-->
                        </div>
                        <div class="small-6 columns text-center">
                           <!--<xsl:call-template name="next-divGen-Link">
                              <xsl:with-param name="thisDivGenType" select="@type"/>
                              <xsl:with-param name="thisLanguage" select="@xml:lang"/>
                           </xsl:call-template>-->
                        </div>
                     </div>
                     <xsl:if test="$subTocDepth >= 0">
                        <xsl:call-template name="subtoc"/>
                     </xsl:if>
                     <xsl:call-template name="startHook"/>
                     
                     <!-- VSTAVI VSEBINO tabele -->
                     <xsl:call-template name="person-tei"/>
                     
                  </section>
               </div>
               <xsl:call-template name="bodyEndHook"/>
            </body>
         </html>
      </xsl:result-document>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc></desc>
   </doc>
   <xsl:template name="person-tei">
      <dl id="{@xml:id}">
         <dt>
            <xsl:choose>
               <xsl:when test="$element-gloss-teiHeader = 'true'">
                  <xsl:call-template name="node-gloss"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="name()"/>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@*">
               <xsl:call-template name="teiHeader-dl-atributes"/>
            </xsl:if>
         </dt>
         <dd>
            <xsl:call-template name="teiHeader-dl"/>
         </dd>
      </dl>
   </xsl:template>
   
</xsl:stylesheet>

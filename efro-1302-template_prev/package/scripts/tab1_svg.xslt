﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:fhir="http://hl7.org/fhir" version="1.0">
	<xsl:output method="html" />
	<xsl:param name="pref" select="pref" />
	<xsl:template match="/">

														<div id="sequence" class="tab-pane fade in active">
															<h3>
																<a name="description" />
																Description
															</h3>
															<p>
																<xsl:value-of select="/fhir:ExampleScenario/fhir:description/@value" />
															</p>
															<h4>
																<a name="preconditions" />
																Pre-Conditions
															</h4>
															<p>
																<xsl:value-of select="/fhir:ExampleScenario/fhir:process/fhir:preConditions/@value" />
															</p>
															<h4>
																<a name="postconditions" />
																Post Conditions
															</h4>
															<p>
																<xsl:value-of select="/fhir:ExampleScenario/fhir:process/fhir:postConditions/@value" />
															</p>
															<p />
<!-- @Lloyd: how do I refer here not to "scenario-allergy" but to {{filename}}.svg where filename is the actual file that is being processed ? -->
															<xsl:value-of select="unparsed-text('../../input/images/scenario-allergy.svg')" disable-output-escaping="yes" />

														</div>



	</xsl:template>

	<xsl:template match="fhir:actor">
		<tr>
			<td>
				<b>
					<xsl:value-of select="fhir:name/@value" />
				</b>
			</td>
			<td>
				<xsl:value-of select="fhir:type/@value" />
			</td>
			<td>
				<xsl:value-of select="fhir:description/@value" />
			</td>
		</tr>
	</xsl:template>


	<xsl:template match="/fhir:ExampleScenario/fhir:process">
		<!--		<h3><xsl:value-of select="title/@value"/></h3> <br/>  -->
		<div class="container">
					<!-- Áreas -->
					<div>
						<div>Main Flow</div>
						<!-- /Área -->
  <table class="cols">
    <tbody>
      <tr>
        <th>Step</th>
        <th>Description</th>
        <th>Operation</th>
        <th>Request</th>
        <th>Response</th>
        <th>z</th>
        <th>x</th>
        <th>x</th>
        <th>x</th>
      </tr>

									<xsl:apply-templates select="fhir:step" />
					
    </tbody>
  </table>

					</div>
				</div>
	</xsl:template>


	<xsl:template match="fhir:process">
		<xsl:value-of select="fhir:title/@value" />
			<xsl:apply-templates select="./fhir:step" />
	</xsl:template>


	<xsl:template match="fhir:step">
		<!-- Each Step -->
      <tr>
				<a href="#{position()}" />
				<xsl:apply-templates select="./fhir:operation" />
	  </tr>
	</xsl:template>

	<xsl:template match="fhir:operation">
		<td>
		<a name="p2">
			<xsl:value-of select="fhir:number/@value" />
		<xsl:value-of select="fhir:name/@value" />
		</a>
		</td>
		<td>
		<xsl:value-of select="fhir:description/@value" />
		</td>
		<td>
		RQ:<xsl:apply-templates select="./fhir:request" />
		
		</td>
		<td>
		RP:<xsl:apply-templates select="./fhir:response" />
		</td>
	</xsl:template>

	
	
	
	
	<xsl:template match="alternative">
		<a name="p2">
			Alternative:
			<xsl:value-of select="number/@value" />
		</a>
		<xsl:value-of select="name/@value" />
		<xsl:value-of select="description/@value" />
		<!-- IF STEP IS ALTERNATIVE -->
				<xsl:apply-templates select="./option" />

	</xsl:template>
	<xsl:template match="option">
		<xsl:variable name="id" select="position()" />
		<xsl:variable name="optionname" select="./description/@value" />
				<a class="accordion-toggle" data-parent="{$id}" data-toggle="collapse" href="#{$id}">
					<xsl:value-of select="$id" />
					-
					<xsl:value-of select="./description/@value" />
				</a>
			<!-- Serviços -->
				<xsl:apply-templates select="./*" />
			<!-- /Serviços -->
	</xsl:template>
	<xsl:template match="pause">(pause)</xsl:template>

	<xsl:template match="fhir:request">
		<b>Request</b>
		(
		<xsl:value-of select="../fhir:receiver/@value" />
		-
		<xsl:value-of select="../fhir:initiator/@value" />
		):
		<xsl:apply-templates select="./fhir:resourceId" />
		<br/>
	</xsl:template>

	<xsl:template match="fhir:response">
		<b>Response</b>
		(
		<xsl:value-of select="../fhir:receiver/@value" />
		-
		<xsl:value-of select="../fhir:initiator/@value" />
		):
		<xsl:apply-templates select="./fhir:resourceId" />
		<br/>
	</xsl:template>
	<xsl:template match="fhir:resourceId">
		<xsl:variable name="iid" select="./@value" />
		<a href="example-instances.html#{/fhir:ExampleScenario/fhir:instance[fhir:resourceId/@value=$iid]/fhir:resourceId/@value}">
			<xsl:value-of select="/fhir:ExampleScenario/fhir:instance[fhir:resourceId/@value=$iid]/fhir:name/@value" />
		</a>
	</xsl:template>

	<xsl:template match="fhir:resourceType">
		<p />
		<xsl:variable name="thisResourceType" select="./@value" />
		<h3>
			<xsl:value-of select="$thisResourceType" />
		</h3>
		<table class="grid">
			<tbody>
				<tr>
					<th>Artifact</th>
					<th>Version</th>
					<th>Description</th>
					<th>Created by step</th>
					<th>Creating actor</th>
				</tr>
				<xsl:apply-templates select="../../fhir:instance[fhir:resourceType/@value=$thisResourceType]" />
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="fhir:instance">
	
		<xsl:variable name="thisResourceId" select="./fhir:resourceId/@value" />
		<xsl:variable name="versions" select="count(./fhir:version)" />

		<tr >
			<td rowspan="{$versions+1}">
				<a name="{resourceId/@value}" href="../fhir:examples/{resourceId/@value}">
					<b>
						<xsl:value-of select="fhir:name/@value" />
					</b>
				</a>
			</td>

			<td>
(<xsl:value-of select="$versions"/>)
			</td> 
			<td>
				<b><xsl:value-of select="fhir:description/@value" /></b>
			</td>
			<td  colspan="3">
						
			</td>		
		</tr>		
	        <xsl:apply-templates select="./fhir:version" />		
		

	</xsl:template>
	

	<xsl:template match="fhir:version">

		<tr>
			<td>
		<xsl:value-of select="fhir:versionId/@value" />
			</td>
			<td>
		<xsl:value-of select="fhir:description/@value" />
			</td>
		</tr>

	</xsl:template>
			

	
</xsl:stylesheet>

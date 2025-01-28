<%@ Page Title="" Language="VB" MasterPageFile="~/Pagina.master" AutoEventWireup="false" CodeFile="Psicologia.aspx.vb" Inherits="HistoriaClinica_Psicologia" %>

<asp:Content ID="Content1" ContentPlaceHolderID="H" runat="Server">
    <!-- <link href="../Estilos/jquery-ui.css" rel="stylesheet" /> -->
    <link href="../Estilos/AccountChooser.css" rel="stylesheet" />
    <style>
        .Cursor {
            cursor: pointer;
        }

        .LimpiarFilas {
            cursor: pointer;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="N" runat="Server">
    Psicología
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="B" runat="Server">
    <asp:BarraHerramientas ID="BH" runat="server" BotonBuscar="True" BotonImprimir="True" BotonAnular="True" BotonAprobar="True" />
    <table>
        <tr>
            <td class="BHEnabled" id="BH_TdEvolucion">
                <asp:ImageButton ID="ImageButton1" OnClientClick="return ImprimirEvolucion();"
                    alt="Imprimir Evoluciones" ToolTip="Imprimir Evoluciones"
                    runat="server" ImageUrl="~/Imagenes/OrdenServicio.png" /><br />
                Evoluciones
            </td>
        </tr>
    </table>
    <div style="float: right; padding-top: 7px; width: 320px; text-align: right;">
        <span style="color: #FFFFFF; font-size: 30px; font-weight: bold; padding-bottom: 20px;" id="SpanIdHistoriaClinica"></span>
        <span style="color: #FFFFFF; font-size: 30px; font-weight: bold; padding-bottom: 20px;">- </span>
        <span style="color: #FFFFFF; font-size: 30px; font-weight: bold; padding-bottom: 20px;" id="SpanEstado"></span>
    </div>
</asp:Content>
<%@ Register Src="~/Componentes/Diagnosticos.ascx" TagPrefix="asp" TagName="Diagnosticos" %>
<asp:Content ID="Content4" ContentPlaceHolderID="C" runat="Server">
    <asp:HiddenField ID="HdfIdPsicologia" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="HdfIdOrdenServicio" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="HdfIdOrdenServicioControl" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="HdfEstado" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="HdfGenero" runat="server" ClientIDMode="Static" />
    <fieldset>
        <legend>Datos del paciente</legend>
        <table>
            <tr>
                <td>Municipio:<br />
                    <asp:TextBox ID="TxtMunicipio" runat="server" Width="290px" ClientIDMode="Static" />
                    <asp:HiddenField ID="HdfMunicipio" runat="server" ClientIDMode="Static" />
                    <asp:AutoCompleteExtender ID="AceTxtMunicipio" runat="server" MinimumPrefixLength="1" TargetControlID="TxtMunicipio"
                        ServiceMethod="NombresMunicipiosAutocomplete" FirstRowSelected="True" CompletionListCssClass="ContenedorLista" Enabled="True"
                        CompletionListItemCssClass="ItemLista" CompletionInterval="1" CompletionListHighlightedItemCssClass="SeleccionItemLista"
                        OnClientItemSelected="AsignarCodigoMunicipio" BehaviorID="AceTxtMunicipio" UseContextKey="True" DelimiterCharacters="" ServicePath="">
                    </asp:AutoCompleteExtender>
                </td>
                <td>Fecha:<br />
                    <asp:TextBox ID="TxtFecha" runat="server" Width="85px" ClientIDMode="Static" />
                    <asp:FilteredTextBoxExtender ID="FtTxtFecha" runat="server" Enabled="True" FilterType="Custom, Numbers" TargetControlID="TxtFecha" ValidChars="/"></asp:FilteredTextBoxExtender>
                    <asp:CalendarExtender ID="CetTxtFecha" runat="server" Enabled="True" PopupPosition="BottomRight" TargetControlID="TxtFecha"></asp:CalendarExtender>
                </td>
                <td>Tipo:<br>
                    <asp:TextBox ID="TxtTipoIdentificacion" CssClass="readonly" runat="server" Width="30px" ClientIDMode="Static" disabled="true" />
                </td>
                <td>N° Identificación:<br>
                    <asp:TextBox ID="TxtNumeroIdentificacion" CssClass="readonly" runat="server" Width="145px" ClientIDMode="Static" onkeydown="return false;" />
                </td>
                <td>Nombre:<br>
                    <asp:TextBox ID="TxtNombre" CssClass="readonly" runat="server" Width="410px" ClientIDMode="Static" disabled="true" />
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td>Fecha de Nacimiento:<br>
                    <asp:TextBox ID="TxtFechaNacimiento" runat="server" Width="145px" ClientIDMode="Static" CssClass="TextoAlCentro readonly" disabled="true" />
                </td>
                <td>Edad:<br>
                    <asp:TextBox ID="TxtEdad" CssClass="readonly" runat="server" Width="65px" ClientIDMode="Static" disabled="true" />
                </td>
                <td>Género:<br>
                    <asp:TextBox ID="TxtGenero" CssClass="readonly" runat="server" Width="100px" ClientIDMode="Static" disabled="true" />
                </td>
                <td>Estado Civil:<br>
                    <asp:TextBox ID="TxtEstadoCivil" CssClass="readonly" runat="server" Width="110px" ClientIDMode="Static" disabled="true" />
                </td>
                <td>Dirección:<br>
                    <asp:TextBox ID="TxtDireccion" CssClass="readonly" runat="server" Width="268px" ClientIDMode="Static" disabled="true" />
                </td>
                <td>Teléfono:<br>
                    <asp:TextBox ID="TxtTelefonos" CssClass="readonly" runat="server" Width="130px" ClientIDMode="Static" disabled="true" />
                </td>
                <td>Celular:<br>
                    <asp:TextBox ID="TxtCelulares" CssClass="readonly" runat="server" Width="130px" ClientIDMode="Static" disabled="true" />
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td>Entidad:<br>
                    <asp:TextBox ID="TxtEmpresa" CssClass="readonly" runat="server" Width="245px" ClientIDMode="Static" disabled="true" />
                </td>
                <td>Ocupación:<br>
                    <asp:TextBox ID="TxtCargo" CssClass="readonly" runat="server" Width="245px" ClientIDMode="Static" disabled="true" />
                </td>
                <td>Nivel Académico:<br />
                    <asp:TextBox ID="TxtNivelAcademico" runat="server" ClientIDMode="Static" Width="230px" disabled="true" CssClass="readonly"></asp:TextBox>
                </td>
                <td>Profesión:<br />
                    <asp:TextBox ID="TxtProfesion" runat="server" ClientIDMode="Static" Width="240px" disabled="true" CssClass="readonly"></asp:TextBox>
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td>Nombre del Acompañante:<br />
                    <asp:TextBox ID="TxtNombreAcudiente" runat="server" Width="480px" ClientIDMode="Static" />
                </td>
                <td>Parentesco:<br />
                    <asp:TextBox ID="TxtParentesco" runat="server" Width="310px" ClientIDMode="Static" />
                </td>
                <td>Teléfono del Acompañante:<br />
                    <asp:TextBox ID="TxtTelefonoAcudiente" runat="server" Width="183px" ClientIDMode="Static" />
                </td>
            </tr>
        </table>
        <br>
    </fieldset>
    <asp:TabContainer runat="server" ID="TcPsicologia" ClientIDMode="Static" Width="998" ScrollBars="None" ActiveTabIndex="0">
        <asp:TabPanel runat="server" ID="TpAnamnesis">
            <HeaderTemplate>
                Datos de la Consulta
            </HeaderTemplate>
            <ContentTemplate>
                <fieldset style="padding: 7px">
                    <legend>Motivo de la Consulta:</legend>
                    <asp:TextBox ID="TxtDescripcionMotivoConsulta" runat="server" ClientIDMode="Static" Rows="8" TextMode="MultiLine" Width="969"></asp:TextBox>
                </fieldset>
                <fieldset style="padding: 7px">
                    <legend>Enfermedad Actual (Historico):</legend>
                    <asp:TextBox ID="TxtEnfermedadActual" runat="server" ClientIDMode="Static" Rows="8" TextMode="MultiLine" Width="958"></asp:TextBox>
                </fieldset>
            </ContentTemplate>
        </asp:TabPanel>
        <asp:TabPanel runat="server" ID="TpConcepto">
            <HeaderTemplate>
                Desarrollo Descriptivo de la Sesión
            </HeaderTemplate>
            <ContentTemplate>
                <fieldset style="padding: 7px; float: left;">
                    <legend></legend>
                    <asp:TextBox ID="TxtConcepto" runat="server" ClientIDMode="Static" Rows="16" TextMode="MultiLine" Width="965" Height="250"></asp:TextBox>
                </fieldset>
                <fieldset class="Invisible" style="margin-left: 20px; padding: 7px; float: left;">
                    <legend></legend>
                    <asp:TextBox ID="TxtPlanTratamiento" runat="server" ClientIDMode="Static" Rows="16" TextMode="MultiLine" Width="450"></asp:TextBox>
                </fieldset>
            </ContentTemplate>
        </asp:TabPanel>
        <asp:TabPanel runat="server" ID="TpDiagnosticoCIE10">
            <HeaderTemplate>
                Diagnóstico CIE-10
            </HeaderTemplate>
            <ContentTemplate>
                <fieldset id="FDocumentosExternos" runat="server">
                    <legend>Exámenes Diagnósticos y Documentos Externos en Ésta Atención</legend>
                    <table runat="server">
                        <tr>
                            <td>Nombre del Documento Externo:<br />
                                <asp:TextBox ID="TxtNombreExamen" runat="server" Width="250px" ClientIDMode="Static"></asp:TextBox>
                            </td>
                            <td>Observaciones:<br />
                                <asp:TextBox ID="TxtResultado" runat="server" Width="570px " ClientIDMode="Static"></asp:TextBox>
                            </td>
                            <td class="TextoAlCentro">Subir Documento: <small id="SmAsyncFuFoto" runat="server" class="Ayuda ArchivoPermitido" title="Imagenes, Documentos"><i class="fa fa-question-circle"></i></small>
                                <br />
                                <asp:AsyncFileUpload ID="AsyncFuFoto" ClientIDMode="Static" runat="server" OnClientUploadComplete="CargaCompletaArchivo"
                                    Width="100px" UploaderStyle="Modern" Style="display: inline-block;" OnClientUploadStarted="IniciaCarga" OnClientUploadError="ErrorCarga" />
                            </td>
                        </tr>
                    </table>
                    <br />
                    <table id="TbExamenes" class="Tabla">
                        <tr>
                            <th style="width: 250px">Nombre del Documento</th>
                            <th style="width: 347px">Observaciones</th>
                            <th style="width: 100px">Fecha</th>
                            <th style="width: 180px">Usuario de Creación</th>
                            <th style="width: 30px">Ver</th>
                            <th style="width: 30px"></th>
                        </tr>
                    </table>
                </fieldset>
                <br />
                <asp:Diagnosticos runat="server" ID="CuDiagnosticos" />
                <fieldset style="padding: 7px">
                    <legend>Procedimiento a Seguir / Próximos Convocados</legend>
                    <asp:TextBox ID="TxtEstres" runat="server" ClientIDMode="Static" Rows="8" TextMode="MultiLine" Width="969"></asp:TextBox>
                </fieldset>
            </ContentTemplate>
        </asp:TabPanel>

        <asp:TabPanel runat="server" ID="TpEvaluacionPsicoemocional">
            <HeaderTemplate>
                Descripción de la Familia
            </HeaderTemplate>
            <ContentTemplate>
                <fieldset>
                    <legend></legend>
                    <asp:TextBox ID="TxtLabilidadEmocional" runat="server" ClientIDMode="Static" Rows="19" TextMode="MultiLine" Width="969"></asp:TextBox>
                </fieldset>
                <div class="Invisible" style="width: 485px; float: left;">


                    <fieldset style="padding: 7px">
                        <legend>SOMNOLENCIA</legend>
                        <asp:TextBox ID="TxtDistimia" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                    </fieldset>
                    <fieldset style="padding: 7px">
                        <legend>ANHEDONIA</legend>
                        <asp:TextBox ID="TxtAnhedonia" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                    </fieldset>
                    <fieldset style="padding: 7px">
                        <legend>AGRESIVIDAD</legend>
                        <asp:TextBox ID="TxtAgresividad" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                    </fieldset>
                    <fieldset style="padding: 7px">
                        <legend>FUGA DE IDEAS</legend>
                        <asp:TextBox ID="TxtFugaIdeas" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                    </fieldset>
                </div>
                <div class="Invisible" style="width: 485px; float: right;">
                    <fieldset style="padding: 7px">
                        <legend>BLOQUEO DE PENSAMIENTOS</legend>
                        <asp:TextBox ID="TxtBloqueoPensamientos" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                    </fieldset>
                    <fieldset style="padding: 7px">
                        <legend>IDEACIÓN SUICIDA</legend>
                        <asp:TextBox ID="TxtIdeacionSuicida" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                    </fieldset>
                    <fieldset style="padding: 7px">
                        <legend>INTENTO DE SUICIDIO</legend>
                        <asp:TextBox ID="TxtIntentoSuicidio" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                    </fieldset>
                    <fieldset style="padding: 7px">
                        <legend>OBSERVACIÓN (Relación al riesgo comportamental)</legend>
                        <asp:TextBox ID="TxtObservacionComportamental" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                    </fieldset>
                    <fieldset style="padding: 7px">
                        <legend>ANSIEDAD</legend>
                        <asp:TextBox ID="TxtAnsiedad" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                    </fieldset>
                </div>
            </ContentTemplate>
        </asp:TabPanel>




        <asp:TabPanel runat="server" ID="TpEvoluciones">
            <HeaderTemplate>
                Evoluciones
            </HeaderTemplate>
            <ContentTemplate>
                <div id="p1">
                    <fieldset class="FEvolucionFecha">
                        <legend>Evolución</legend>
                        <asp:HiddenField ID="HdfIdEvolucion" runat="server" ClientIDMode="Static" />
                        <table>
                            <tr>
                                <td>Fecha y hora de la Evolución:<br />
                                    <asp:TextBox ID="TxtFechaEvolucion" runat="server" Width="87px" ClientIDMode="Static" />
                                    <asp:FilteredTextBoxExtender ID="FtTxtFechaEvolucion" runat="server" Enabled="True" FilterType="Custom, Numbers" TargetControlID="TxtFechaEvolucion" ValidChars="/"></asp:FilteredTextBoxExtender>
                                    <asp:CalendarExtender ID="CetTxtFechaEvolucion" runat="server" Enabled="True" PopupPosition="BottomRight" TargetControlID="TxtFechaEvolucion"></asp:CalendarExtender>
                                    <asp:DropDownList ID="CbHora" runat="server" ClientIDMode="Static" Width="65px">
                                        <asp:ListItem Text="Horas" Value=""></asp:ListItem>
                                        <asp:ListItem Text="01" Value="01"></asp:ListItem>
                                        <asp:ListItem Text="02" Value="02"></asp:ListItem>
                                        <asp:ListItem Text="03" Value="03"></asp:ListItem>
                                        <asp:ListItem Text="04" Value="04"></asp:ListItem>
                                        <asp:ListItem Text="05" Value="05"></asp:ListItem>
                                        <asp:ListItem Text="06" Value="06"></asp:ListItem>
                                        <asp:ListItem Text="07" Value="07"></asp:ListItem>
                                        <asp:ListItem Text="08" Value="08"></asp:ListItem>
                                        <asp:ListItem Text="09" Value="09"></asp:ListItem>
                                        <asp:ListItem Text="10" Value="10"></asp:ListItem>
                                        <asp:ListItem Text="11" Value="11"></asp:ListItem>
                                        <asp:ListItem Text="12" Value="12"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="CbMinutos" runat="server" ClientIDMode="Static" Width="70px">
                                        <asp:ListItem Text="Minutos" Value=""></asp:ListItem>
                                        <asp:ListItem Text="00" Value="00"></asp:ListItem>
                                        <asp:ListItem Text="01" Value="01"></asp:ListItem>
                                        <asp:ListItem Text="02" Value="02"></asp:ListItem>
                                        <asp:ListItem Text="03" Value="03"></asp:ListItem>
                                        <asp:ListItem Text="04" Value="04"></asp:ListItem>
                                        <asp:ListItem Text="05" Value="05"></asp:ListItem>
                                        <asp:ListItem Text="06" Value="06"></asp:ListItem>
                                        <asp:ListItem Text="07" Value="07"></asp:ListItem>
                                        <asp:ListItem Text="08" Value="08"></asp:ListItem>
                                        <asp:ListItem Text="09" Value="09"></asp:ListItem>
                                        <asp:ListItem Text="10" Value="10"></asp:ListItem>
                                        <asp:ListItem Text="11" Value="11"></asp:ListItem>
                                        <asp:ListItem Text="12" Value="12"></asp:ListItem>
                                        <asp:ListItem Text="13" Value="13"></asp:ListItem>
                                        <asp:ListItem Text="14" Value="14"></asp:ListItem>
                                        <asp:ListItem Text="15" Value="15"></asp:ListItem>
                                        <asp:ListItem Text="16" Value="16"></asp:ListItem>
                                        <asp:ListItem Text="17" Value="17"></asp:ListItem>
                                        <asp:ListItem Text="18" Value="18"></asp:ListItem>
                                        <asp:ListItem Text="19" Value="19"></asp:ListItem>
                                        <asp:ListItem Text="20" Value="20"></asp:ListItem>
                                        <asp:ListItem Text="21" Value="21"></asp:ListItem>
                                        <asp:ListItem Text="22" Value="22"></asp:ListItem>
                                        <asp:ListItem Text="23" Value="23"></asp:ListItem>
                                        <asp:ListItem Text="24" Value="24"></asp:ListItem>
                                        <asp:ListItem Text="25" Value="25"></asp:ListItem>
                                        <asp:ListItem Text="26" Value="26"></asp:ListItem>
                                        <asp:ListItem Text="27" Value="27"></asp:ListItem>
                                        <asp:ListItem Text="28" Value="28"></asp:ListItem>
                                        <asp:ListItem Text="29" Value="29"></asp:ListItem>
                                        <asp:ListItem Text="30" Value="30"></asp:ListItem>
                                        <asp:ListItem Text="31" Value="31"></asp:ListItem>
                                        <asp:ListItem Text="32" Value="32"></asp:ListItem>
                                        <asp:ListItem Text="33" Value="33"></asp:ListItem>
                                        <asp:ListItem Text="34" Value="34"></asp:ListItem>
                                        <asp:ListItem Text="35" Value="35"></asp:ListItem>
                                        <asp:ListItem Text="36" Value="36"></asp:ListItem>
                                        <asp:ListItem Text="37" Value="37"></asp:ListItem>
                                        <asp:ListItem Text="38" Value="38"></asp:ListItem>
                                        <asp:ListItem Text="39" Value="39"></asp:ListItem>
                                        <asp:ListItem Text="40" Value="40"></asp:ListItem>
                                        <asp:ListItem Text="41" Value="41"></asp:ListItem>
                                        <asp:ListItem Text="42" Value="42"></asp:ListItem>
                                        <asp:ListItem Text="43" Value="43"></asp:ListItem>
                                        <asp:ListItem Text="44" Value="44"></asp:ListItem>
                                        <asp:ListItem Text="45" Value="45"></asp:ListItem>
                                        <asp:ListItem Text="46" Value="46"></asp:ListItem>
                                        <asp:ListItem Text="47" Value="47"></asp:ListItem>
                                        <asp:ListItem Text="48" Value="48"></asp:ListItem>
                                        <asp:ListItem Text="49" Value="49"></asp:ListItem>
                                        <asp:ListItem Text="50" Value="50"></asp:ListItem>
                                        <asp:ListItem Text="51" Value="51"></asp:ListItem>
                                        <asp:ListItem Text="52" Value="52"></asp:ListItem>
                                        <asp:ListItem Text="53" Value="53"></asp:ListItem>
                                        <asp:ListItem Text="54" Value="54"></asp:ListItem>
                                        <asp:ListItem Text="55" Value="55"></asp:ListItem>
                                        <asp:ListItem Text="56" Value="56"></asp:ListItem>
                                        <asp:ListItem Text="57" Value="57"></asp:ListItem>
                                        <asp:ListItem Text="58" Value="58"></asp:ListItem>
                                        <asp:ListItem Text="59" Value="59"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="CbAmPm" runat="server" ClientIDMode="Static" Width="70px">
                                        <asp:ListItem Text="AM/PM" Value=""></asp:ListItem>
                                        <asp:ListItem Text="AM" Value="AM"></asp:ListItem>
                                        <asp:ListItem Text="PM" Value="PM"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>

                                <td></td>
                            </tr>
                        </table>
                        <table>
                            <tr>
                                <td>
                                    <asp:TextBox ID="TxtEvolucion" ClientIDMode="Static" runat="server" Rows="8" TextMode="MultiLine" Width="947"></asp:TextBox>
                                </td>
                                <td>
                                    <input type="image" id="BtnAgregarEvolucion" src="../Imagenes/Guardar.png"
                                        alt="" title="Agregar Evolucion" value="button" onclick="return GuardarEvolucion();" />
                                </td>
                            </tr>
                        </table>
                        <asp:HiddenField ID="HdfEvolucionFecha" ClientIDMode="Static" runat="server" />
                        <table class="Tabla" id="TbEvolucionFecha">
                            <tr>
                                <th style="width: 105px">Fecha</th>
                                <th style="width: 130px">Profesional</th>
                                <th style="width: 690px">Evolución</th>
                                <th style="width: 20px">
                                    <input type="checkbox" />
                                </th>
                            </tr>
                        </table>
                    </fieldset>
                </div>
            </ContentTemplate>
        </asp:TabPanel>
    </asp:TabContainer>

    <div class="Invisible">
        <asp:TabContainer runat="server" ID="TabContainer1" ClientIDMode="Static" Width="998" ScrollBars="None" ActiveTabIndex="0">

            <asp:TabPanel runat="server" ID="TpOmed" HeaderText="Ordenes Médicas">
                <ContentTemplate>
                    <asp:TabContainer runat="server" ID="TcOm" ClientIDMode="Static" Height="600" Width="995" ScrollBars="None" ActiveTabIndex="0">

                        <asp:TabPanel runat="server" ID="TpOm">
                            <HeaderTemplate>
                                Ordenes de Medicamentos
                            </HeaderTemplate>
                            <ContentTemplate>
                                <table class="NoBloquear Botones">
                                    <tr>
                                        <td>Orden de Medicamentos Número:  &nbsp;
                                        </td>
                                        <td>
                                            <select onchange="CargarMedicamentos();" id="CbNumeroOrdenMedicamento">
                                                <option>1</option>
                                            </select>&nbsp;
                                        </td>
                                        <td class="BHEnabledBuscar" onclick="NuevaOrdenMedica();" style="cursor: pointer;">
                                            <img src="../BarraHerramientas/Botones/BtnNuevoDisabled.png" style="width: 20px;" />
                                        </td>
                                    </tr>
                                </table>
                                <fieldset>
                                    <legend></legend>

                                    <table id="TbMedicamento">
                                        <tr>
                                            <td>Nombre del Medicamento
           <br />
                                                <div>
                                                    <asp:TextBox ID="TxtMedicamento" ClientIDMode="Static" runat="server" Width="620px" autocomplete="off" />
                                                    <asp:AutoCompleteExtender ID="AceTxtMedicamento" runat="server" MinimumPrefixLength="1"
                                                        TargetControlID="TxtMedicamento" ServiceMethod="Comun_MedicamentosAutocomplete" FirstRowSelected="True"
                                                        CompletionListCssClass="ContenedorLista" CompletionListItemCssClass="ItemLista"
                                                        CompletionInterval="1" CompletionListHighlightedItemCssClass="SeleccionItemLista"
                                                        OnClientItemSelected="AsignarIdMedicamento" BehaviorID="AceTxtMedicamento"
                                                        DelimiterCharacters="" Enabled="True" ServicePath="">
                                                    </asp:AutoCompleteExtender>
                                                    <asp:HiddenField ID="HdfIdMedicamento" ClientIDMode="Static" runat="server" />
                                                </div>
                                            </td>
                                            <td>
                                                <table width="100%" style="border: 1px outset #C0C0C0;">
                                                    <tr>
                                                        <td>Cantidad<br />
                                                            <asp:TextBox ID="TxtCantidadPosologia" OnKeyUp="Posologia();" ClientIDMode="Static" runat="server" Width="77px" Style="text-align: center" />
                                                            <asp:FilteredTextBoxExtender ID="TxtCantidadPosologia_FilteredTextBoxExtender" runat="server"
                                                                Enabled="True" FilterType="Numbers" TargetControlID="TxtCantidadPosologia"></asp:FilteredTextBoxExtender>
                                                        </td>
                                                        <td>Frecuencia<br />
                                                            <asp:TextBox ID="TxtDosis" ClientIDMode="Static" OnKeyUp="Posologia();" runat="server" Width="78px" Style="text-align: center" />
                                                            <asp:FilteredTextBoxExtender
                                                                ID="FilteredTextBoxExtender_TxtDosis" runat="server" Enabled="True" FilterType="Numbers"
                                                                TargetControlID="TxtDosis"></asp:FilteredTextBoxExtender>
                                                        </td>
                                                        <td>Días<br />
                                                            <asp:TextBox ID="TxtDias" OnKeyUp="Posologia();" ClientIDMode="Static" runat="server" Width="77px" Style="text-align: center" />
                                                            <asp:FilteredTextBoxExtender
                                                                ID="FilteredTextBoxExtender_TxtDias" runat="server" Enabled="True" FilterType="Numbers"
                                                                TargetControlID="TxtDias"></asp:FilteredTextBoxExtender>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="TxtPosologia" ClientIDMode="Static" runat="server" Width="249px" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>Cantidad
                                <br />
                                                <asp:TextBox ID="TxtCantidadMed" ClientIDMode="Static" runat="server" Style="text-align: center" Width="50px" />
                                                <asp:FilteredTextBoxExtender ID="FeTxtCantidadMed" runat="server" FilterType="Numbers"
                                                    TargetControlID="TxtCantidadMed" Enabled="True"></asp:FilteredTextBoxExtender>
                                            </td>
                                            <td>
                                                <img alt="" src="../Imagenes/Guardar.png" onclick="GuardarMedicamento();" id="Img2"
                                                    style="cursor: pointer" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:HiddenField ID="HdfTbMedicamentos" ClientIDMode="Static" runat="server" />
                                    <br />
                                    <table class="Tabla" id="TbMedicamentos">
                                        <tr>
                                            <th style="width: 500px">Nombre del Medicamento
                                            </th>
                                            <th style="width: 80px">Cantidad
                                            </th>
                                            <th style="width: 335px">Posología 
                                            </th>
                                            <th style="width: 20px">
                                                <img alt="" src="../Imagenes/ImprimirBlanco.png" onclick="return ImprimeOrdenMedicamento();" id="Img5"
                                                    style="cursor: pointer" /></th>
                                        </tr>
                                    </table>
                                </fieldset>
                            </ContentTemplate>
                        </asp:TabPanel>

                        <asp:TabPanel runat="server" ID="TpSv">
                            <HeaderTemplate>
                                Ordenes a Servicios
                            </HeaderTemplate>
                            <ContentTemplate>
                                <table class="Botones">
                                    <tr>
                                        <td>Orden a Servicios Número:  &nbsp;
                                        </td>
                                        <td>
                                            <select onchange="CargarServicios();" id="CbNumeroOrdenServicio">
                                                <option>1</option>
                                            </select>&nbsp;
                                        </td>
                                        <td class="BHEnabledBuscar" onclick="NuevaOrdenServicio();" style="cursor: pointer;">
                                            <img src="../BarraHerramientas/Botones/BtnNuevoDisabled.png" style="width: 20px;" />
                                        </td>
                                    </tr>
                                </table>
                                <fieldset>
                                    <legend></legend>

                                    <table id="TbServicio">
                                        <tr>
                                            <td>Nombre del Servicio
                                <br />
                                                <div>
                                                    <asp:TextBox ID="TxtServicio" ClientIDMode="Static" runat="server" Width="880px" autocomplete="off" />
                                                    <asp:AutoCompleteExtender ID="AceTxtServicio" runat="server" MinimumPrefixLength="1"
                                                        TargetControlID="TxtServicio" ServiceMethod="Comun_ServiciosAutocomplete" FirstRowSelected="True"
                                                        CompletionListCssClass="ContenedorLista" CompletionListItemCssClass="ItemLista"
                                                        CompletionInterval="1" CompletionListHighlightedItemCssClass="SeleccionItemLista"
                                                        OnClientItemSelected="AsignarIdServicio" BehaviorID="AceTxtServicio"
                                                        DelimiterCharacters="" Enabled="True" ServicePath="">
                                                    </asp:AutoCompleteExtender>
                                                    <asp:HiddenField ID="HdfIdServicio" ClientIDMode="Static" runat="server" />
                                                </div>
                                            </td>
                                            <td>Cantidad<br />
                                                <asp:TextBox ClientIDMode="Static" ID="TxtCantidadServicio" onKeyPress="return esEntero(event);" runat="server" Width="50px" CssClass="TextoAlCentro"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Observaciones<br />
                                                <asp:TextBox ID="TxtObservacionesServicios" ClientIDMode="Static" runat="server" Width="900px" autocomplete="off" />
                                            </td>
                                            <td>
                                                <br />
                                                <img alt="" src="../Imagenes/Guardar.png" onclick="GuardarServicio();" id="Img3"
                                                    style="cursor: pointer" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:HiddenField ID="HdfTbServicio" ClientIDMode="Static" runat="server" />
                                    <br />
                                    <table class="Tabla" id="TbServicios">
                                        <tr>
                                            <th style="width: 425px">Nombre del Servicio
                                            </th>
                                            <th style="width: 425px">Observaciones
                                            </th>
                                            <th style="width: 80px">Cantidad
                                            </th>
                                            <th style="width: 20px">
                                                <img alt="" src="../Imagenes/ImprimirBlanco.png" onclick="return ImprimeOrdenServicio();" id="Img6"
                                                    style="cursor: pointer" /></th>
                                        </tr>
                                    </table>
                                </fieldset>
                            </ContentTemplate>
                        </asp:TabPanel>

                        <asp:TabPanel runat="server" ID="TpOR">
                            <HeaderTemplate>
                                Ordenes de Remisiones a Especialista
                            </HeaderTemplate>
                            <ContentTemplate>
                                <table class="Botones">
                                    <tr>
                                        <td>Orden de Remisión a Especialidad Número:  &nbsp;
                                        </td>
                                        <td>
                                            <select onchange="CargarRemisiones();" id="CbNumeroOrdenRemision">
                                                <option>1</option>
                                            </select>&nbsp;
                                        </td>
                                        <td class="BHEnabledBuscar" onclick="NuevaOrdenRemision();" style="cursor: pointer;">
                                            <img src="../BarraHerramientas/Botones/BtnNuevoDisabled.png" style="width: 20px;" />
                                        </td>
                                    </tr>
                                </table>
                                <fieldset>
                                    <legend></legend>

                                    <table id="TbOrdenRemision">
                                        <tr>
                                            <td>Nombre de la Especialidad
                                <br />
                                                <div>
                                                    <asp:TextBox ID="TxtEspecialidad" ClientIDMode="Static" runat="server" Width="900px" autocomplete="off" />
                                                    <asp:AutoCompleteExtender ID="AceTxtEspecialidad" runat="server" MinimumPrefixLength="1"
                                                        TargetControlID="TxtEspecialidad" ServiceMethod="Comun_EspecialidadesSaludAutocomplete" FirstRowSelected="True"
                                                        CompletionListCssClass="ContenedorLista" CompletionListItemCssClass="ItemLista"
                                                        CompletionInterval="1" CompletionListHighlightedItemCssClass="SeleccionItemLista"
                                                        OnClientItemSelected="AsignarCodigoEspecialidad" BehaviorID="AceTxtEspecialidad"
                                                        DelimiterCharacters="" Enabled="True" ServicePath="">
                                                    </asp:AutoCompleteExtender>
                                                    <asp:HiddenField ID="HdfCodigoEspecialidad" ClientIDMode="Static" runat="server" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Motivo de la Remisión<br />
                                                <asp:TextBox ID="TxtMotivoRemision" ClientIDMode="Static" runat="server" Width="900px" autocomplete="off" />
                                            </td>
                                            <td>
                                                <br />
                                                <img alt="" src="../Imagenes/Guardar.png" onclick="GuardarOrdenRemision();" id="Img4"
                                                    style="cursor: pointer" />
                                            </td>
                                        </tr>
                                    </table>

                                    <asp:HiddenField ID="HdfTbOrdenRemision" ClientIDMode="Static" runat="server" />
                                    <br />
                                    <table class="Tabla" id="TbOrdenRemisiones">
                                        <tr>
                                            <th style="width: 450px">Nombre de la Especialidad</th>
                                            <th style="width: 445px">Motivo de la Remisión</th>
                                            <th style="width: 20px">
                                                <img alt="" src="../Imagenes/ImprimirBlanco.png" onclick="return ImprimeOrdenRemision();" id="Img7"
                                                    style="cursor: pointer" />
                                            </th>
                                        </tr>
                                    </table>
                                </fieldset>
                            </ContentTemplate>
                        </asp:TabPanel>

                        <asp:TabPanel runat="server" ID="TpOI">
                            <HeaderTemplate>Ordenes de Incapacidades</HeaderTemplate>
                            <ContentTemplate>
                                <table class="Botones">
                                    <tr>
                                        <td>Orden de Incapacidad Número:&nbsp;
                                        </td>
                                        <td>
                                            <select onchange="CargarOrdenIncapacidad();" id="CbNumeroOrdenIncapacidad">
                                                <option>1</option>
                                            </select>
                                            &nbsp;
                                        </td>
                                        <td onclick="NuevaOrdenIncapacidad();" class="BHEnabledBuscar" style="cursor: pointer;">
                                            <img src="../BarraHerramientas/Botones/BtnNuevoDisabled.png" style="width: 20px;" />
                                        </td>
                                    </tr>
                                </table>

                                <fieldset>
                                    <table>
                                        <tr>
                                            <td>Motivo de la Incapacidad:<br />
                                                <asp:TextBox ID="TxtMotivoIncapacidad" runat="server" ClientIDMode="Static" Width="925px" Rows="3" TextMode="MultiLine"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                    <table>
                                        <tr>
                                            <td>Desde:<br />
                                                <asp:TextBox ID="TxtFechaInicial" runat="server" ClientIDMode="Static" Width="80px" onchange="CalcularDiasIncapacidad(this,'Inicial')"></asp:TextBox>
                                                <asp:FilteredTextBoxExtender ID="FeTxtFechaInicial" runat="server" Enabled="True" FilterType="Custom, Numbers"
                                                    TargetControlID="TxtFechaInicial" ValidChars="/"></asp:FilteredTextBoxExtender>
                                                <asp:CalendarExtender ID="CeTxtFechaInicial" runat="server" Enabled="True" PopupPosition="BottomRight"
                                                    TargetControlID="TxtFechaInicial"></asp:CalendarExtender>
                                            </td>
                                            <td>Hasta:<br />
                                                <asp:TextBox ID="TxtFechaFinal" runat="server" ClientIDMode="Static" Width="80px" onchange="CalcularDiasIncapacidad(this,'Final')"></asp:TextBox>
                                                <asp:FilteredTextBoxExtender ID="FeTxtFechaFinal" runat="server" Enabled="True" FilterType="Custom, Numbers"
                                                    TargetControlID="TxtFechaFinal" ValidChars="/"></asp:FilteredTextBoxExtender>
                                                <asp:CalendarExtender ID="CeTxtFechaFinal" runat="server" Enabled="True" PopupPosition="BottomRight"
                                                    TargetControlID="TxtFechaFinal"></asp:CalendarExtender>
                                            </td>
                                            <td>Dias:<br />
                                                <asp:TextBox ID="TxtDiasDeIncapacidad" runat="server" ClientIDMode="Static" Width="80px" onKeyPress="return esInteger(event);" onchange="CalcularDiasIncapacidad(this,'Dias')"></asp:TextBox>
                                            </td>
                                            <td>Tipo:<br />
                                                <asp:DropDownList ID="CbTipoIncapacidad" ClientIDMode="Static" runat="server" Width="213px">
                                                    <asp:ListItem Text="SELECCIONE" Value=""></asp:ListItem>
                                                    <asp:ListItem>NO APLICA</asp:ListItem>
                                                    <asp:ListItem>TEMPORAL</asp:ListItem>
                                                    <asp:ListItem>PERMANENTE</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                <br />
                                                <img alt="" src="../Imagenes/Guardar.png" onclick="GuardarOrdenIncapacidad();" id="Img9"
                                                    style="cursor: pointer" />
                                            </td>
                                        </tr>
                                    </table>

                                    <asp:HiddenField ID="HdfOrdenIncapacidad" ClientIDMode="Static" runat="server" />
                                    <br />
                                    <table class="Tabla" id="TbOrdenIncapacidad">
                                        <tr>
                                            <th style="width: 750px">Motivo de la Incapacidad
                                            </th>
                                            <th style="width: 100px">Dias
                                            </th>
                                            <th style="width: 80px">Tipo
                                            </th>
                                            <th style="width: 20px">
                                                <img alt="" src="../Imagenes/ImprimirBlanco.png" onclick="return ImprimeOrdenIncapacidades();" id="Img10"
                                                    style="cursor: pointer" /></th>
                                        </tr>
                                    </table>
                                </fieldset>

                            </ContentTemplate>
                        </asp:TabPanel>

                        <asp:TabPanel runat="server" ID="TpOc">
                            <HeaderTemplate>Ordenes de Certificaciones</HeaderTemplate>
                            <ContentTemplate>
                                <table class="Botones">
                                    <tr>
                                        <td>Orden de Certificación Número:&nbsp;
                                        </td>
                                        <td>
                                            <select onchange="CargarOrdenCertificacion();" id="CbNumeroOrdenCertificacion">
                                                <option>1</option>
                                            </select>
                                            &nbsp;
                                        </td>
                                        <td onclick="NuevaOrdenCertificacion();" class="BHEnabledBuscar" style="cursor: pointer;">
                                            <img src="../BarraHerramientas/Botones/BtnNuevoDisabled.png" style="width: 20px;" />
                                        </td>
                                        <td onclick="GuardarOrdenCertificacion();" class="BHEnabledBuscar" style="cursor: pointer;">
                                            <img src="../Imagenes/Guardar.png" style="width: 20px;" />
                                        </td>
                                        <td onclick="ImprimeOrdenCertificacion();" class="BHEnabledBuscar" style="cursor: pointer;">
                                            <img src="../Imagenes/Imprimir.png" style="width: 20px;" />
                                        </td>
                                    </tr>
                                </table>
                                <table>
                                    <tr>
                                        <td>Descripción de la Certificación:<br />
                                            <asp:TextBox ID="TxtDescripcionCertificacion" runat="server" ClientIDMode="Static" TextMode="MultiLine" Style="display: none;"></asp:TextBox>
                                            <asp:HiddenField ID="HdfIdOrdenCertificacion" ClientIDMode="Static" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:TabPanel>
                    </asp:TabContainer>
                </ContentTemplate>
            </asp:TabPanel>

            <asp:TabPanel runat="server" ID="TpPsicologiaAdultos">
                <HeaderTemplate>
                    Historia Psicología Adultos
                </HeaderTemplate>
                <ContentTemplate>
                    <asp:TabContainer runat="server" ID="TcObjetivosFonoaudiologia" ClientIDMode="Static" Width="998" ScrollBars="None" ActiveTabIndex="0">
                        <asp:TabPanel runat="server" ID="TpDatosGenerales">
                            <HeaderTemplate>
                                Datos Personales
                            </HeaderTemplate>
                            <ContentTemplate>
                                <div style="width: 485px; float: left;">
                                    <fieldset style="padding: 7px">
                                        <legend>HIJOS</legend>
                                        <asp:TextBox ID="TxtHijos" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>VIVE CON</legend>
                                        <asp:TextBox ID="TxtViveCon" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>FAMILIA CONOCE EL DX</legend>
                                        <asp:TextBox ID="TxtFamiliaConoceDx" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>REACCIONES</legend>
                                        <asp:TextBox ID="TxtReacciones" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>PAREJA ESTABLE</legend>
                                        <asp:TextBox ID="TxtParejaEstable" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>PAREJA CONOCE EL DX</legend>
                                        <asp:TextBox ID="TxtParejaConoceDx" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>TATUAJES</legend>
                                        <asp:TextBox ID="TxtTatuajes" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>PIERCINGS</legend>
                                        <asp:TextBox ID="TxtPiercings" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>EJERCICIOS</legend>
                                        <asp:TextBox ID="TxtEjercicios" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                </div>
                                <div style="width: 485px; float: right;">
                                    <fieldset style="padding: 7px">
                                        <legend>ANTECEDENTES QUIRÚRGICOS</legend>
                                        <asp:TextBox ID="TxtAntecedentesQuirurgicos" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>ANTECEDENTES ITS</legend>
                                        <asp:TextBox ID="TxtAntecedentesIts" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>ANTECEDENTES FARMACO DEPENDIENTES</legend>
                                        <asp:TextBox ID="TxtAntecedentesFarmacoDependientes" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>ANTECEDENTES PSIQUIÁTRICOS</legend>
                                        <asp:TextBox ID="TxtAntecedentesPsiquiatricos" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>ANTECEDENTES MORBIDOS PERSONALES</legend>
                                        <asp:TextBox ID="TxtAntecedentesMorbidosPersonales" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>ANTECEDENTES MORBIDOS FAMILIARES</legend>
                                        <asp:TextBox ID="TxtAntecedentesMorbidosFamiliares" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>CONSUMO S.P.A. (Sustancias Psicoactivas)</legend>
                                        <asp:TextBox ID="TxtFuma" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                    <fieldset style="padding: 7px">
                                        <legend>USO DE PRESERVATIVOS</legend>
                                        <asp:TextBox ID="TxtPreservativos" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                                    </fieldset>
                                </div>
                            </ContentTemplate>
                        </asp:TabPanel>

                    </asp:TabContainer>
                </ContentTemplate>
            </asp:TabPanel>
            <asp:TabPanel runat="server" ID="TpPsicologiaPediatrica">
                <HeaderTemplate>
                    Historia Psicología Pediatrica
                </HeaderTemplate>
                <ContentTemplate>
                    <div style="text-align: center; font-size: 1em; font-weight: bold; padding: 5px; height: 16px">DATOS GENERALES</div>
                    <fieldset style="padding: 7px">
                        <legend>DATOS PERSONALES</legend>
                        <table>
                            <tr>
                                <td>Escolaridad:<br />
                                    <asp:TextBox ID="TxtEscolaridad" runat="server" Width="195px" ClientIDMode="Static" />
                                </td>
                                <td>Dx VIH (+):<br />
                                    <asp:TextBox ID="TxtDxVIH" runat="server" Width="180px" ClientIDMode="Static" />
                                </td>
                                <td class="Radios" id="TdRedApoyo" style="width: 100px;">Red de Apoyo:<br />
                                    <asp:RadioButton ID="RdbSi" runat="server" Text="Si" value="Si" GroupName="Frecuencia" />
                                    <asp:RadioButton ID="RdbNo" runat="server" Text="No" value="No" GroupName="Frecuencia" />
                                </td>
                                <td>Carga Viral (Previa):<br />
                                    <asp:TextBox ID="TxtCargaViral" runat="server" Width="180px" ClientIDMode="Static" />
                                </td>
                                <td>Antecedentes Farmaco Dependientes:<br />
                                    <asp:TextBox ID="TxtAntecedentesFarmacoDependientePediatrica" runat="server" Width="280px" ClientIDMode="Static" />
                                </td>
                            </tr>
                        </table>
                        <table>
                            <tr>
                            </tr>
                        </table>
                    </fieldset>
                    <fieldset style="padding: 7px">
                        <legend>DATOS FAMILIARES</legend>
                        <table>
                            <tr>
                                <td>No. Hermanos:<br />
                                    <asp:TextBox ID="TxtNumeroHermanos" runat="server" Width="100px" ClientIDMode="Static" />
                                </td>
                                <td>Hermanos:<br />
                                    <asp:TextBox ID="TxtHermanos" runat="server" ClientIDMode="Static" Width="853px"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                        <table>
                            <tr>
                                <td>Nombre del Padre:
                                <br />
                                    <asp:TextBox ID="TxtNombrePadre" runat="server" ClientIDMode="Static" Width="435"></asp:TextBox>
                                </td>
                                <td>Ocupación del Padre:
                                <br />
                                    <asp:TextBox ID="TxtOcupacionPadre" runat="server" Width="388" ClientIDMode="Static" />
                                </td>
                                <td>Edad del Padre:
                                <br />
                                    <asp:TextBox ID="TxtEdadPadre" runat="server" Width="125" ClientIDMode="Static" />
                                </td>
                            </tr>
                            <tr>
                                <td>Nombre de la Madre:
                                <br />
                                    <asp:TextBox ID="TxtNombreMadre" runat="server" ClientIDMode="Static" Width="435"></asp:TextBox>
                                </td>
                                <td>Ocupación de la Madre:
                                <br />
                                    <asp:TextBox ID="TxtOcupacionMadre" runat="server" Width="388" ClientIDMode="Static" />
                                </td>
                                <td>Edad de la Madre:
                                <br />
                                    <asp:TextBox ID="TxtEdadMadre" runat="server" Width="125" ClientIDMode="Static" />
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                    <div style="text-align: center; font-size: 1em; font-weight: bold; padding: 5px; height: 16px">EVALUACIÓN PSICOEMOCIONAL</div>
                    <div style="width: 485px; float: left;">
                        <%--<fieldset style="padding: 7px">
            <legend>SOPORTE FAMILIAR/SOCIAL</legend>
            <asp:TextBox ID="TxtSoporteFamiliarSocial" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
          </fieldset>--%>
                        <fieldset style="padding: 7px">
                            <legend>ACTITUD DE LA ENFERMEDAD(Padres)</legend>
                            <asp:TextBox ID="TxtActitudEnfermedad" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                        </fieldset>
                        <fieldset style="padding: 7px">
                            <legend>RED DE APOYO(Neofamiliar)</legend>
                            <asp:TextBox ID="TxtRedApoyoNeoFamiliar" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                        </fieldset>
                        <fieldset style="padding: 7px">
                            <legend>INSOMNIO</legend>
                            <asp:TextBox ID="TxtFactorCognitivoPerceptual" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                        </fieldset>
                    </div>
                    <div style="width: 485px; float: right;">
                        <fieldset style="padding: 7px">
                            <legend>FACTOR RIESGO COMPORTAMENTAL</legend>
                            <asp:TextBox ID="TxtFactorRiesgoComportamental" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                        </fieldset>
                        <%--<fieldset style="padding: 7px">
            <legend>DIAGNÓSTICO PSICOLÓGICO</legend>
            <asp:TextBox ID="TxtDiagnosticoPsicologicoPediatrico" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
          </fieldset>--%>
                        <fieldset style="padding: 7px">
                            <legend>OBJETIVO TERAPEUTICO</legend>
                            <asp:TextBox ID="TxtObjetivoTerapeutico" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                        </fieldset>
                        <fieldset style="padding: 7px">
                            <legend>SOMNOLECIA</legend>
                            <asp:TextBox ID="TxtSomnolencia" runat="server" ClientIDMode="Static" Rows="2" TextMode="MultiLine" Width="463"></asp:TextBox>
                        </fieldset>
                    </div>
                </ContentTemplate>
            </asp:TabPanel>
        </asp:TabContainer>
    </div>

    <div id="Monitoreo">
        <asp:Panel ID="PnMonitoreo" CssClass="Encabezado" runat="server" ToolTip="Mostrar/Ocultar Pacientes"
            Width="100%" Style="cursor: pointer;">
            <asp:Image ID="ImgBajarSubir" runat="server" ImageUrl="~/Imagenes/Subir.png" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Hay
   <span id="CantidadPacientes">0</span> pacientes por atender&nbsp;&nbsp;
        </asp:Panel>
        <asp:Panel ID="PnGvTurnos" runat="server" Style="visibility: collapse; overflow: auto; display: none; width: 1015px;">
            <div style="overflow-y: scroll; width: 100%; height: 295px;">
                <asp:HiddenField ID="HdfIdTurno" runat="server" ClientIDMode="Static" />
                <table id="TbTurnos" style="width: 100%" class="Tabla">
                    <tr>
                        <th>
                            <asp:Image Style="cursor: pointer;" ID="ImgCalendario" onclick="AbrirCalendario();" runat="server" ImageUrl="~/Imagenes/Calendario.png" Width="24px" />
                            <asp:TextBox ID="TxtFechaAtencion" onchange="OcultarCalendario();" Style="position: fixed;" ClientIDMode="Static" CssClass="Invisible" runat="server"></asp:TextBox>
                            <asp:CalendarExtender ID="CeTxtFechaAtencion" runat="server" Enabled="True" PopupPosition="BottomRight"
                                TargetControlID="TxtFechaAtencion"></asp:CalendarExtender>
                        </th>
                        <th>Hora Llegada</th>
                        <th>N°. Identificación</th>
                        <th>Nombre</th>
                        <th>Empresa</th>
                    </tr>
                </table>

            </div>
        </asp:Panel>
        <asp:CollapsiblePanelExtender ID="CpPnGvTurnos" runat="server" CollapseControlID="PnMonitoreo"
            Collapsed="True" CollapsedSize="-1" Enabled="True" ExpandControlID="PnMonitoreo"
            TargetControlID="PnGvTurnos" ExpandedSize="300" AutoCollapse="False" AutoExpand="True"
            CollapsedImage="~/imagenes/Subir.png" ImageControlID="ImgBajarSubir" ExpandedImage="~/imagenes/Bajar.png"
            CollapsedText="Mostrar Pacientes" ExpandedText="Ocultar Pacientes" BehaviorID="CpPnGvTurnos"></asp:CollapsiblePanelExtender>
    </div>

    <asp:Panel ID="PnEvolucion" runat="server" Style="display: none;" CssClass="VentanModal">
        <div class="VentanModal-tl"></div>
        <div class="VentanModal-tr"></div>
        <div class="VentanModal-bl"></div>
        <div class="VentanModal-br"></div>
        <div class="VentanModal-tc"></div>
        <div class="VentanModal-bc"></div>
        <div class="VentanModal-cl"></div>
        <div class="VentanModal-cr"></div>
        <div class="VentanModal-cc"></div>
        <div class="VentanModal-Cuerpo" align="center">
            <div class="VentanModal-Titulo">
                Tipo de Atención
        <input id="BtnCerrarEvolucion" runat="server" alt="" src="~/Imagenes/BotonCerrarMensajes.png" onmouseout="RestablecerImagen(this);"
            onmouseover="CambiarImagen(this);" class="CerrarMensaje" type="image" />
            </div>
            <div class="VentanModal-Contenido" style="height: 80px; padding: 20px;">
                <div style="width: 100%; text-align: center;">
                    ¿Qué tipo de Atención se va a prestar?<br />
                    <br />
                    <span class="BtnAzul" onclick="AtencionControl();" style="position: relative; float: right;">Atención por Control</span>
                    <span class="BtnVerde" onclick="AtencionPrimeraVez();" style="position: relative; float: right;">Atención por Primera Vez</span>

                </div>
            </div>
            <div class="cleared">
            </div>
        </div>
    </asp:Panel>
    <asp:ModalPopupExtender ID="MpePnEvolucion" runat="server" Enabled="True" TargetControlID="HdfBuscar"
        CancelControlID="BtnCerrarEvolucion" PopupControlID="PnEvolucion" BackgroundCssClass="VentanModal-Fondo"
        BehaviorID="MpePnEvolucion" Y="200">
    </asp:ModalPopupExtender>

    <asp:Panel ID="PnBuscar" runat="server" Style="display: none;" CssClass="VentanModal">
        <div class="VentanModal-tl">
        </div>
        <div class="VentanModal-tr">
        </div>
        <div class="VentanModal-bl">
        </div>
        <div class="VentanModal-br">
        </div>
        <div class="VentanModal-tc">
        </div>
        <div class="VentanModal-bc">
        </div>
        <div class="VentanModal-cl">
        </div>
        <div class="VentanModal-cr">
        </div>
        <div class="VentanModal-cc">
        </div>
        <div class="VentanModal-Cuerpo" align="center">
            <div class="VentanModal-Titulo">
                Buscar y filtrar por los siguientes ítems
    <input id="BtnCerrarbusqueda" runat="server" alt="" src="~/Imagenes/BotonCerrarMensajes.png"
        onmouseout="RestablecerImagen(this);" onmouseover="CambiarImagen(this);" class="CerrarMensaje"
        type="image" />
            </div>
            <div class="VentanModal-Contenido" style="width: 880px; height: 550px">
                <table style="padding: 10px; margin: 20px; text-align: justify;">
                    <tr>
                        <td>N° Psicología:<br />
                            <asp:TextBox ID="TxtBuscaNoPsicologia" ClientIDMode="Static" runat="server" Width="120px" onkeypress="if (event.keyCode==13){ BuscarVacio();}"></asp:TextBox>
                        </td>
                        <td>N° Identificación:<br />
                            <asp:TextBox ID="TxtBuscaNumeroIdentificacion" runat="server" Width="140px" ClientIDMode="Static" onkeypress="if (event.keyCode==13){ BuscarVacio();}" />
                        </td>
                        <td>Nombre del Paciente:<br />
                            <asp:TextBox ID="TxtBuscaNombreCliente" runat="server" AutoComplete="off" ClientIDMode="Static" Width="420px" onkeypress="if (event.keyCode==13){ BuscarVacio();}" />
                        </td>
                        <td runat="server" id="TdBuscar" class="BHEnabledBuscar" onclick="BuscarVacio();" style="cursor: pointer;">
                            <asp:ImageButton ID="BtnAceptaBuscar" runat="server" OnClientClick="return false;" ToolTip="Realizar busqueda de registros" CausesValidation="False" ImageUrl="~/Imagenes/Buscar.png" Enabled="True" /><br />
                            Busca
                        </td>
                    </tr>
                </table>
                <div style="width: 100%; text-align: left;">
                    <table class="Tabla">
                        <tr>
                            <th style="width: 30px"></th>
                            <th style="width: 100px">N° Psicología</th>
                            <th style="width: 130px">N° Identificación</th>
                            <th style="width: 460px">Nombre del Paciente</th>
                            <th style="width: 100px">Fecha</th>
                        </tr>
                    </table>
                    <div style="overflow-y: scroll; width: 880px; height: 400px">
                        <table class="Tabla" id="TbBuscar" style="position: relative; top: -2px;">
                            <tr id="TrBuscar">
                                <td style="height: 0px; width: 30px;"></td>
                                <td style="height: 0px; width: 100px"></td>
                                <td style="height: 0px; width: 130px"></td>
                                <td style="height: 0px; width: 460px"></td>
                                <td style="height: 0px; width: 100px"></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="cleared">
            </div>
        </div>
    </asp:Panel>
    <asp:ModalPopupExtender ID="MpePnBuscar" runat="server" Enabled="True" TargetControlID="HdfBuscar"
        CancelControlID="BtnCerrarbusqueda" BackgroundCssClass="VentanModal-Fondo" PopupControlID="PnBuscar"
        BehaviorID="MpePnBuscar" Y="30">
    </asp:ModalPopupExtender>
    <asp:Label ID="HdfBuscar" runat="server"></asp:Label>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="S" runat="Server">
    <!-- <script src="../Scripts/jquery-ui.js" type="text/javascript"></script> -->
    <script src="../Scripts/ckeditor/ckeditor.js"></script>
    <script src="../Scripts/ckeditor/jqueryckeditor.js"></script>
    <script src="../Scripts/moment.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            if ((typeof (Sys) === 'undefined') == false) { Sys.Application.add_load(AsignarClick); AsignarClick(); }
        });

        window.onbeforeunload = function PreguntarAntesSalir() {
            return 'Si sale y aun no ha guardado, la información se perderá.';
        }


        function Anular() {
            if (confirm("¿Desea anular este registro?")) {
                Progreso(true);
                PageMethods.HistoriaClinica_PsicologiasAnula($get('HdfIdPsicologia').value, UsuarioDelSistema(), HistoriaClinica_PsicologiasAnulaOK, Errores);
            }
            return false;
        }

        function HistoriaClinica_PsicologiasAnulaOK(Resultado) {
            Progreso(false);
            if (Resultado != "0") {
                Mensaje("Informacion", "Anulada con éxito");
                $get("SpanEstado").innerText = " ANULADA";
                $get("HdfEstado").value = "ANULADA";
                $('#TpEvoluciones :input').attr('disabled', true);
                $('#TbDiagnosticos :input').attr('disabled', true);
                Bloquear();
            }

        }


        function AsignarClick() {
            //Documentos externos INICIO
            ReporsitorioFunciones.DocumentosPermitidos();
            ReporsitorioFunciones.AyudaCargueArchivo('ArchivoPermitido');
            $("#AsyncFuFoto div:eq(1)").addClass("Ocultar");

            //Documentos externos FIN

            $('textarea#TxtDescripcionCertificacion').ckeditor();
            $(".Radios").buttonset();
            Nuevo();
            Cursor();
            Bloquear();
            $get("SpanEstado").innerText = $get("HdfEstado").value;
            $get("SpanIdHistoriaClinica").innerText = $get("HdfIdPsicologia").value;
            $('#B_BH_TdAnular').unbind('click');
            $('#B_BH_TdAprobar').click(function () { AprobarPsicologia(); return false; });
            $('#B_BH_TdAnular').click(function () { if ($get("HdfIdPsicologia").value == "") { Mensaje("Fallo", "Para ANULAR debe tener abierta una Psicología, por favor revise y vuelva a intentarlo"); return false; } Anular(); return false; });
            $('#B_BH_TdNuevo').click(function () { if (confirm("Si aún no ha guardado perderá toda la información. ¿Desea limpiar los campos?")) { Nuevo(); } return false; });
            $('#B_BH_TdBuscar').click(function () { $find("MpePnBuscar").show(); return false; });
            $('#B_BH_TdGuardar').click(function () { GuardarPsicologia(); return false; });
            $('#B_BH_TdImprimir').click(function () {
                if ($get("HdfIdPsicologia").value == "") { Mensaje("Fallo", "Para imprimir debe tener abierta una Historia de Psicología, por favor revise y vuelva a intentarlo."); return false; }
                Progreso(true);
                var Reporte = '../HistoriaClinica/Psicologia.ashx?Id=' + $get("HdfIdPsicologia").value; open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes');
                Progreso(false);
                //$.ajax({
                // type: "POST",
                // data: "{ 'IdHistoriaClinica': '" + $get("HdfIdPsicologia").value +
                //     "','Reporte': '" + "Psicologia" +
                //        "','Carpeta': '" + "HistoriasClinicas/Psicologias" +
                //         "','Pa': '" + "HistoriaClinica.PsicologiasGenerarReporteSelecciona" +
                //       "'}",
                // url: "Psicologia.aspx/GenerarReportes",
                // contentType: "application/json; charset=utf-8",
                // dataType: "json",
                // success: function (Respuesta) {
                //  Progreso(false);
                //  if (Respuesta.d == "1") {
                //   var Reporte = '../HistoriaClinica/HistoriasClinicas/Psicologias/' + $get("HdfIdPsicologia").value + ".pdf?rd=" + Math.random();
                //   open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
                //  }
                // },
                // error: function (Respuesta) { Progreso(false); Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                //});
                return false;
            });
            MostrarCantPaci();

            $('th input:checkbox').change(function () {
                if (this.checked) $('td input:checkbox').prop('checked', true);
                else $('td input:checkbox').prop('checked', false);
            });

        }
        function Cursor() {
            $('#B_BH_TdAprobar').addClass('Cursor');
            $('#B_BH_TdBuscar').addClass('Cursor');
            $('#B_BH_TdGuardar').addClass('Cursor');
            $('#B_BH_TdImprimir').addClass('Cursor');
            $("input[type='checkbox']+label").addClass('Cursor');
        }

        function Nuevo() {
            Proceso = true;
            $get("HdfIdPsicologia").value = "";
            $("input[type='text']").not("[id='TxtMunicipio'],[id='TxtFecha']").val("");
            $("textarea").val("");
            $("input[type='radio']").removeAttr('checked');
            $(".Radios").buttonset('refresh');
            $("input[type='checkbox']").prop("checked", false);
            $("select").selectedIndex = 0;

            $get("HdfIdOrdenServicio").value = "";
            $get("HdfEstado").value = "";
            $get("HdfGenero").value = "";
            $get("HdfIdEvolucion").value = "";
            Bloquear();

            $("#TbDiagnosticos tbody").children('tr:not(:last)').remove();
            $("#TbEvolucionFecha tbody").children('tr:not(:first)').remove();
            $("#TbServicios tbody").children('tr:not(:first)').remove();
            $("#TbOrdenIncapacidad tbody").children('tr:not(:first)').remove();
            $("#TbMedicamentos tbody").children('tr:not(:first)').remove();
            $("#TbOrdenRemisiones tbody").children('tr:not(:first)').remove();


            $(".fielderror").removeClass('fielderror');
            AsignarIdPsicologiaEstado();
            Proceso = false;
        }
        function Desbloquear() {
            $get("TxtNombreAcudiente").disabled = false;
            Sys.UI.DomElement.removeCssClass($get("TxtNombreAcudiente"), 'readonly');
            $get("TxtParentesco").disabled = false;
            Sys.UI.DomElement.removeCssClass($get("TxtParentesco"), 'readonly');
            $get("TxtTelefonoAcudiente").disabled = false;
            Sys.UI.DomElement.removeCssClass($get("TxtTelefonoAcudiente"), 'readonly');
            $get("TxtMunicipio").disabled = false;
            Sys.UI.DomElement.removeCssClass($get("TxtMunicipio"), 'readonly');
            $get("TxtFecha").disabled = false;
            Sys.UI.DomElement.removeCssClass($get("TxtFecha"), 'readonly');
            Deshabilitar(Cajas, false);
        }
        function Bloquear() {
            $get("TxtNombreAcudiente").disabled = true;
            Sys.UI.DomElement.addCssClass($get("TxtNombreAcudiente"), 'readonly');
            $get("TxtParentesco").disabled = true;
            Sys.UI.DomElement.addCssClass($get("TxtParentesco"), 'readonly');
            $get("TxtTelefonoAcudiente").disabled = true;
            Sys.UI.DomElement.addCssClass($get("TxtTelefonoAcudiente"), 'readonly');
            $get("TxtMunicipio").disabled = true;
            Sys.UI.DomElement.addCssClass($get("TxtMunicipio"), 'readonly');
            $get("TxtFecha").disabled = true;
            Sys.UI.DomElement.addCssClass($get("TxtFecha"), 'readonly');
            Deshabilitar(Cajas, true);
        }
        var Cajas = ['TxtDescripcionMotivoConsulta', 'TxtEnfermedadActual', 'TxtConcepto', 'TxtEstres', 'TxtLabilidadEmocional'];
        function Deshabilitar(Ids, Deshabilitado) {
            $.each(Ids, function (indice, Id) {
                $get(Id).disabled = Deshabilitado;
                if (Deshabilitado)
                    Sys.UI.DomElement.addCssClass($get(Id), 'readonly');
                else
                    Sys.UI.DomElement.removeCssClass($get(Id), 'readonly');
            });
        }
        function AsignarIdPsicologiaEstado() {
            if ($get("HdfEstado").value != "ABIERTA")
                Bloquear();
            $get("SpanEstado").innerText = $get("HdfEstado").value;
            $get("SpanIdHistoriaClinica").innerText = $get("HdfIdPsicologia").value;
        }
        function AsignarCodigoMunicipio(source, eventArgs) {
            $get("HdfMunicipio").value = eventArgs.get_value();
        }


        var verificayaprueba;
        function AprobarPsicologia() {
            if ($get("HdfIdPsicologia").value == "") {
                Mensaje("Fallo", "Para aprobar debe tener abierta una Historia Clinica de Psicología, por favor revise y vuelva a intentarlo.");
            }
            else {
                if (confirm("¿Esta seguro que desea aprobar la Historia Clinica de Psicología?")) {
                    verificayaprueba = "SI";
                    Aprobar();
                }
            }
        }



        function Aprobar() {
            if ($get("HdfIdPsicologia").value != "")
                PageMethods.HistoriaClinica_PsicologiasAprueba($get("HdfIdPsicologia").value, $get("TxtNumeroIdentificacion").value, HistoriaClinica_PsicologiasApruebaOK, Errores);
        }
        function HistoriaClinica_PsicologiasApruebaOK(Respuesta) {
            Respuesta = Respuesta.split("|");
            for (var Valor in Respuesta) {
                Item = Respuesta[Valor].split("-");
                if (Item[0] == "Relacion") {

                    Prefijo = "Cb";
                    if (Item[1] == "0")
                        $("#FDiagnosticos").addClass('fielderror');
                    else
                        $("#FDiagnosticos").removeClass('fielderror');
                }
                else
                    Prefijo = "Txt";

            }
            if (verificayaprueba == "SI")
                AprobarOK();
            if (verificayaprueba == "Guardado") {
                if ($(".ErrorValidacion").length > 0)
                    Mensaje("Informacion", "Guardado con éxito, Por favor llene los contenedores de color rojo.");
                else
                    Mensaje("Informacion", "Guardado con éxito");
            }
        }
        function AprobarOK() {
            if ($get("HdfEstado").value == "ABIERTA") {
                if (!$(".ErrorValidacion").length > 0) {
                    Progreso(true);
                    PageMethods.HistoriaClinica_PsicologiasApruebaOK($get("HdfIdPsicologia").value, "Psicologia", "HistoriasClinicas", "HistoriaClinica.PsicologiasGenerarReporteSelecciona", UsuarioDelSistema(), HistoriaClinica_PsicologiasApruebaOKR, Errores);
                }
                else {
                    Mensaje("Advertencia", "No es posible aprobar la Historia de Psicología porque contiene errores. Por favor corrigir los campos en rojo, Guardar e intentar de nuevo.");
                    verificayaprueba = "NO";
                }
            }
            else {
                Mensaje("Advertencia", "No es posible aprobar una Historia de Psicologia Anulada o CERRADA.");
            }
        }
        function HistoriaClinica_PsicologiasApruebaOKR(Resultado) {
            if (Resultado > 0) {
                Mensaje("Informacion", "Aprobado con éxito.");
                $get("HdfEstado").value = "CERRADA";
                $get("SpanEstado").innerText = $get("HdfEstado").value;
                verificayaprueba = "NO";
                Bloquear();
                $.ajax({
                    type: "POST",
                    data: "{ 'IdHistoriaClinica': '" + $get("HdfIdPsicologia").value +
                        "','Reporte': '" + "Psicologia" +
                           "','Carpeta': '" + "HistoriasClinicas/Psicologias" +
                            "','Pa': '" + "HistoriaClinica.PsicologiasGenerarReporteSelecciona" +
                          "'}",
                    url: "Psicologia.aspx/GenerarReportes",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (Respuesta) {
                        Progreso(false);
                        if (Respuesta.d == "1") {
                            var Reporte = '../HistoriaClinica/HistoriasClinicas/Psicologias/' + $get("HdfIdPsicologia").value + ".pdf?rd=" + Math.random();
                            open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
                        }
                    },
                    error: function (Respuesta) { Progreso(false); Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                });
                return false;
            }
            else {
                Mensaje("Advertencia", "Error al aprobar.");
                verificayaprueba = "NO";
            }
            Progreso(false);
        }

        function BuscarVacio() {
            if ($get("TxtBuscaNoPsicologia").value == "" && $get("TxtBuscaNumeroIdentificacion").value == "" && $get("TxtBuscaNombreCliente").value == "") {
                Mensaje("Informacion", "Debe llenar por lo menos un criterio para generar la búsqueda.");
            }
            else {
                Progreso(true);
                $.ajax({
                    type: "POST",
                    data: "{ 'NumeroIdentificacion': '" + $get("TxtBuscaNumeroIdentificacion").value +
                      "','Nombre': '" + $get("TxtBuscaNombreCliente").value +
                      "','IdPsicologia': '" + $get("TxtBuscaNoPsicologia").value +
                      "'}",
                    url: "Psicologia.aspx/HistoriaClinica_BuscarPsicologia",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (Respuesta) {
                        Progreso(false);
                        $.each($(".LimpiarFilas"), function (i, fila) {
                            $(fila).remove();
                        });
                        if (JSON.parse(Respuesta.d).Datos.length > 0) {
                            $.each(JSON.parse(Respuesta.d).Datos, function (i, Datos) {
                                Celdas = [CrearCeldaSeleccionar("SeleccionarBusqueda"), CrearCelda(Datos.IdPsicologia, "left", "", "SeleccionarBusqueda(this)"), CrearCelda(Datos.NumeroIdentificacion, "left", "", "SeleccionarBusqueda(this)"), CrearCelda(Datos.Nombre, "left", "", "SeleccionarBusqueda(this)"), CrearCelda(Datos.Fecha, "Left", "", "SeleccionarBusqueda(this)")];
                                $get("TbBuscar").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "LimpiarFilas"));
                            });
                            $('#TbBuscar td').click(function () { SeleccionarBusqueda(this); return false; });
                        }
                        else
                            Mensaje("Informacion", "La búsqueda no arrojó ningún resultado.");
                    },
                    error: function (Respuesta) { Progreso(false); Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                });
            }
        }
        function SeleccionarBusqueda(Boton) {
            Progreso(true);
            $find("MpePnBuscar").hide();
            if (Boton == "[object HTMLImageElement]" || Boton == "[object HTMLInputElement]")
                FilaBuscar = Boton.parentNode.parentNode;
            else
                FilaBuscar = Boton.parentNode;
            Buscar(FilaBuscar.cells[1].innerText);
            AsignarIdPsicologiaEstado();
            return false;
        }
        function Buscar(Dato, IdOrdenServicio) {
            if (Dato != "") {
                Nuevo();
                $get("HdfIdPsicologia").value = Dato;
                $.ajax({
                    type: "POST",
                    data: "{ 'IdPsicologia': '" + $get("HdfIdPsicologia").value +
                        "'}",
                    url: "Psicologia.aspx/HistoriaClinica_PsicologiaSelecciona",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (Respuesta) {
                        Respuesta = JSON.parse(Respuesta.d);
                        for (var Item in Respuesta.Datos[0].Encabezado[0]) {
                            var valor = Respuesta.Datos[0].Encabezado[0][Item];
                            if (!(typeof valor === 'object')) {
                                switch (Item) {
                                    case 'Estado':
                                        $get('SpanEstado').innerHTML = valor;
                                        $get("Hdf" + Item).value = valor;
                                        break;
                                    case 'IdOrdenServicio':
                                        $get("Hdf" + Item).value = valor;
                                        break;
                                    case 'Genero':
                                        $get("Hdf" + Item).value = valor;
                                    default:
                                        $get("Txt" + Item).value = valor;
                                }
                            }
                        }
                        for (var Item in Respuesta.Datos[1].Anamnesis[0]) {
                            var valor = Respuesta.Datos[1].Anamnesis[0][Item];
                            if (typeof valor === 'object') { }
                            else {
                                switch (Item) {
                                    case 'MotivoConsulta':
                                        if (valor != "") {
                                            $get("Rdb" + valor).checked = true;
                                            $("#" + Item).buttonset('refresh');
                                        }
                                        break;
                                    default:
                                        $get('Txt' + Item).value = valor.replace(/'/gi, '"');
                                        break;
                                }
                            }
                        }
                        for (var Item in Respuesta.Datos[2].PsicologiaAdultosDatosPersonales[0]) {
                            var valor = Respuesta.Datos[2].PsicologiaAdultosDatosPersonales[0][Item];
                            if (typeof valor === 'object') { }
                            else {
                                $get('Txt' + Item).value = valor.replace(/'/gi, '"');
                            }
                        }
                        for (var Item in Respuesta.Datos[3].PsicologiaAdultosEvaluacionPsicoemocional[0]) {
                            var valor = Respuesta.Datos[3].PsicologiaAdultosEvaluacionPsicoemocional[0][Item];
                            if (typeof valor === 'object') { }
                            else {
                                switch (Item) {
                                    case 'Diagnosticos':
                                        $get("Rdb" + valor).checked = true;
                                        $("#Leg" + Item).buttonset('refresh');
                                        break;
                                    default:
                                        $get('Txt' + Item).value = valor.replace(/'/gi, '"');
                                        break;
                                }
                            }
                        }
                        if (Respuesta.Datos[4].Diagnosticos.length > 0) {
                            Diagnosticos.DiagnosticosSelecciona();
                        }

                        //if (Respuesta.Datos[4].HistoricoDiagnosticos.length > 0) {
    //
    //                            Diagnosticos.DiagnosticosSelecciona();
    //                        
 //}

                        for (var Item in Respuesta.Datos[5].HistoriaPsicologiaPediatrica[0]) {
                            var valor = Respuesta.Datos[5].HistoriaPsicologiaPediatrica[0][Item];
                            if (typeof valor === 'object') { }
                            else {
                                switch (Item) {
                                    case 'RedApoyo':
                                        if (valor != "") {
                                            $get("Rdb" + valor).checked = true;
                                            $("#Td" + Item).buttonset('refresh');
                                        }
                                        break;
                                    default:
                                        $get('Txt' + Item).value = valor.replace(/'/gi, '"');
                                        break;
                                }
                            }
                        }
                        for (var Item in Respuesta.Datos[6].Concepto[0]) {
                            var valor = Respuesta.Datos[6].Concepto[0][Item];
                            if (typeof valor === 'object') { }
                            else {
                                $get('Txt' + Item).value = valor.replace(/'/gi, '"');
                            }
                        }
                        if (Respuesta.Datos[7].Evoluciones.length > 0) {
                            $("#TbEvolucionFecha tbody").children('tr:not(:first)').remove();
                            $.each(Respuesta.Datos[7].Evoluciones, function (i, Dato) {
                                Celdas = [CrearCelda(Dato.IdEvolucion, "center", "Invisible"),
                                          CrearCelda(Dato.FechaHoraEvolucion, "center"),
                                          CrearCelda(Dato.UsuarioCreacion, "left"),
                                          CrearCelda(Dato.Evolucion.replace(/'/gi, '"'), "left"),
                                          CrearCelda('<input type="checkbox" />', "center")];
                                $get("TbEvolucionFecha").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "TrEvolucionSeleccionado"));
                            });
                        }

                        if (Respuesta.Datos[8].OrdenesMedicamentos.length > 0) {
                            $("#TbMedicamentos tbody").children('tr:not(:first)').remove();
                            $get('CbNumeroOrdenMedicamento').options.length = 0;
                            $.each(Respuesta.Datos[8].OrdenesMedicamentos, function (i, Dato) {
                                Celdas = [CrearCelda(Dato.IdOrdenMedicamento, "left", "Invisible"),
                                          CrearCelda(Dato.NombreMedicamento, "left"),
                                          CrearCelda(Dato.Cantidad, "center"),
                                          CrearCelda(Dato.Posologia, "left"),
                                          CrearCeldaEliminar("EliminarMedicamento")];
                                $get("TbMedicamentos").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "EliminarMedicamento"));
                            });

                            if ($get('CbNumeroOrdenMedicamento').options.length < Respuesta.Datos[8].OrdenesMedicamentos[0].Numero) {
                                $("#CbNumeroOrdenMedicamento").children('option').remove();
                                for (i = 1; i <= ParsearNumero(Respuesta.Datos[8].OrdenesMedicamentos[0].Numero) ; i++) {
                                    $('#CbNumeroOrdenMedicamento').append("<option value=" + i + ">" + i + "</option>");
                                }
                            }
                            $('#CbNumeroOrdenMedicamento').val(Respuesta.Datos[8].OrdenesMedicamentos[0].Numero);
                        }

                        if (Respuesta.Datos[9].OrdenesServicios.length > 0) {
                            $("#TbServicios tbody").children('tr:not(:first)').remove();
                            $.each(Respuesta.Datos[9].OrdenesServicios, function (i, Dato) {
                                Celdas = [CrearCelda(Dato.IdOrdenServicio, "left", "Invisible"),
                                          CrearCelda(Dato.NombreServicio, "left"),
                                          CrearCelda(Dato.Observaciones, "left"),
                                          CrearCelda(Dato.Cantidad, "center"),
                                          CrearCeldaEliminar("EliminarOrdenServicio")];
                                $get("TbServicios").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "EliminarOrdenServicio"));
                            });

                            if ($get('CbNumeroOrdenServicio').options.length < Respuesta.Datos[9].OrdenesServicios[0].Numero) {
                                $("#CbNumeroOrdenServicio").children('option').remove();
                                for (i = 1; i <= ParsearNumero(Respuesta.Datos[9].OrdenesServicios[0].Numero) ; i++) {
                                    $('#CbNumeroOrdenServicio').append("<option value=" + i + ">" + i + "</option>");
                                }
                            }
                            $('#CbNumeroOrdenServicio').val(Respuesta.Datos[9].OrdenesServicios[0].Numero);
                        }

                        if (Respuesta.Datos[10].OrdenesRemisiones.length > 0) {
                            $("#TbOrdenRemisiones tbody").children('tr:not(:first)').remove();
                            $.each(Respuesta.Datos[10].OrdenesRemisiones, function (i, Dato) {
                                Celdas = [CrearCelda(Dato.IdOrdenRemision, "left", "Invisible"),
                                          CrearCelda(Dato.NombreEspecilidad, "left"),
                                          CrearCelda(Dato.MotivoRemision, "left"),
                                          CrearCeldaEliminar("EliminarOrdenRemision")];
                                $get("TbOrdenRemisiones").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "EliminarOrdenRemision"));
                            });
                            if ($get('CbNumeroOrdenRemision').options.length < Respuesta.Datos[10].OrdenesRemisiones[0].Numero) {
                                $("#CbNumeroOrdenRemision").children('option').remove();

                                for (i = 1; i <= ParsearNumero(Respuesta.Datos[10].OrdenesRemisiones[0].Numero) ; i++) {
                                    $('#CbNumeroOrdenRemision').append("<option value=" + i + ">" + i + "</option>");
                                }
                            }
                            $('#CbNumeroOrdenRemision').val(Respuesta.Datos[10].OrdenesRemisiones[0].Numero);
                        }

                        if (Respuesta.Datos[11].OrdenesIncapacidades.length > 0) {
                            $("#TbOrdenIncapacidad tbody").children('tr:not(:first)').remove();
                            $.each(Respuesta.Datos[11].OrdenesIncapacidades, function (i, Dato) {
                                Celdas = [CrearCelda(Dato.IdOrdenIncapacidad, "left", "Invisible"),
                                          CrearCelda(Dato.MotivoIncapacidad, "left"),
                                          CrearCelda(Dato.DiasIncapacidad, "center"),
                                          CrearCelda(Dato.Tipo, "left"),
                                          CrearCeldaEliminar("EliminarOrdenIncapacidad")];
                                $get("TbOrdenIncapacidad").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "EliminarOrdenIncapacidad"));
                            });

                            if ($get('CbNumeroOrdenIncapacidad').options.length < Respuesta.Datos[11].OrdenesIncapacidades[0].Numero) {
                                $("#CbNumeroOrdenIncapacidad").children('option').remove();

                                for (i = 1; i <= ParsearNumero(Respuesta.Datos[11].OrdenesIncapacidades[0].Numero) ; i++) {
                                    $('#CbNumeroOrdenIncapacidad').append("<option value=" + i + ">" + i + "</option>");
                                }
                            }
                            $('#CbNumeroOrdenIncapacidad').val(Respuesta.Datos[11].OrdenesIncapacidades[0].Numero)
                        }

                        if (Respuesta.Datos[12].OrdenesCertificaciones.length > 0) {
                            $("#TbEvolucionFecha tbody").children('tr:not(:first)').remove();
                            $.each(Respuesta.Datos[12].OrdenesCertificaciones, function (i, Dato) {
                                document.getElementById("HdfIdOrdenCertificacion").value = Dato.IdOrdenCertificacion
                                CKEDITOR.instances['TxtDescripcionCertificacion'].setData(Dato.DescripcionCertificacion);
                            });

                            if ($get('CbNumeroOrdenCertificacion').options.length < Respuesta.Datos[12].OrdenesCertificaciones[0].Numero) {
                                $("#CbNumeroOrdenCertificacion").children('option').remove();
                                for (i = 1; i <= ParsearNumero(Respuesta.Datos[12].OrdenesCertificaciones[0].Numero) ; i++) {
                                    $('#CbNumeroOrdenCertificacion').append("<option value=" + i + ">" + i + "</option>");
                                }
                            }
                            $('#CbNumeroOrdenCertificacion').val(Respuesta.Datos[12].OrdenesCertificaciones[0].Numero);
                        }


                        LlenarTablaExamenDiagnostico();

                        if ($get("HdfEstado").value == "ABIERTA")
                            Desbloquear();
                        else
                            Bloquear();

                        if ($get("HdfEstado").value == "ANULADA") {
                            $('#TpEvoluciones :input').attr('disabled', true);
                            $('#TbDiagnosticos :input').attr('disabled', true);
                        }
                        Progreso(false);
                    },
                    error: function (Respuesta) { Progreso(false); Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                });
            }

        }

        var Datos = {};
        function HacerJson() {
            var NuevosDatos = {};
            $("#Contenido input[type='hidden']").each(function (i, Oculto) {
                NuevosDatos[Oculto.id.substr(3)] = Oculto.value;
            });
            $.extend(true, Datos, NuevosDatos);
            NuevosDatos = { Profesional: UsuarioDelSistema() };
            $.extend(true, Datos, NuevosDatos);

            $("input[type='text']").each(function (i, Text) {
                switch (Text.id.substr(3)) {
                    case 'TipoIdentificacion':
                    case 'Nombre':
                    case 'FechaNacimiento':
                    case 'Edad':
                    case 'Genero':
                    case 'EstadoCivil':
                    case 'Direccion':
                    case 'Telefono':
                    case 'Celulares':
                    case 'Empresa':
                    case 'Cargo':
                    case 'CodigoDiagnostico':
                    case 'Diagnostico':
                    case 'Municipio':
                        break;
                    default:
                        NuevosDatos[Text.id.substr(3)] = Text.value;
                        break;
                }
            });
            $.extend(true, Datos, NuevosDatos);
            $("textarea").each(function (i, TextArea) {
                NuevosDatos[TextArea.id.substr(3)] = TextArea.value;
            });
            $.extend(true, Datos, NuevosDatos);
            $("#Contenido Td").each(function (i, Td) {
                llave = "";
                if (Td.id != "") {
                    $("#" + Td.id + " input[type='radio']:checked").each(function (i, Radio) {
                        Grupo = Radio.parentNode;
                        llave = Radio.id.substr(3);
                    });
                    NuevosDatos[Td.id] = llave;
                }
            });
            $.extend(true, Datos, NuevosDatos);
            $("#LegDiagnosticos").each(function (i, Contenedor) {
                llave = "";
                $("#LegDiagnosticos input[type='radio']:checked").each(function (i, Radio) {
                    Grupo = Radio.parentNode;
                    llave = Radio.id.substr(3);
                });
                NuevosDatos[Contenedor.id] = llave;
            });
            $.extend(true, Datos, NuevosDatos);

        }
        function GuardarPsicologia() {
            if ($get("HdfIdPsicologia").value != "") {
                $(".ErrorValidacion").removeClass("ErrorValidacion");
                if ($get("HdfEstado").value == "ABIERTA" || $get("HdfEstado").value == "CERRADA") {
                    if ($get("TxtEdad").value < '18 AÑOS' || $get("TxtEdad").value > '60 AÑOS') {
                        Validar($get("TxtNombreAcudiente"));
                        Validar($get("TxtTelefonoAcudiente"));
                        Validar($get("TxtParentesco"));
                    }


                    if ($(".ErrorValidacion").length > 0) {
                        Mensaje("Advertencia", "Faltan los datos del acudiente por llenar. Por favor verifique e intente de nuevo.");
                    }
                    else {
                        Progreso(true);
                        HacerJson();
                        $.ajax({
                            type: "POST",
                            data: JSON.stringify(Datos),
                            url: "Psicologia.aspx/HistoriaClinica_PsicologiasInsertaActualiza",
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (Respuesta) {
                                Progreso(false);
                                Respuesta = JSON.parse(Respuesta.d);
                                if (Respuesta.Datos.length > 0) {
                                    //  $get("HdfIdEvolucion").value = Respuesta.Datos[0].IdEvolucionPsicologiaInsertada;
                                    Mensaje("Informacion", "La Historia de Psicología se ha guardado correctamente.");
                                    MostrarCantPaci();
                                }
                                Progreso(false);
                            },
                            error: function (Respuesta) { Progreso(false); Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                        });
                    }
                }
                else {
                    Mensaje("Advertencia", "No se pueden guardar Historias con estado " + $get("HdfEstado").value + ".");
                }
            }
            else {
                Mensaje("Advertencia", "Debe abrir una Historia de Psicología.");
            }
        }

        function AsignarContextKeyDiagnostico(IdAce) {
            $find(IdAce.replace('Txt', 'AceTxt')).set_contextKey($find(IdAce.replace('Txt', 'AceTxt'))._contextKey + "|" + $get('HdfGenero').value + "|" + $get('HdfIdPsicologia').value);
        }
        function AsignarIdDiagnostico(source, eventArgs) {
            var a = eventArgs.get_value();
            var datos = a.split("|");
            if (source.get_contextKey().split("|")[0] == "Codigo") {
                $get("TxtDiagnostico").value = datos[0];
                $get("HdfIdDiagnostico").value = datos[1];
                $get("TxtCodigoDiagnostico").value = datos[1];
            }
            else {
                $get("HdfIdDiagnostico").value = datos[0];
                $get("TxtCodigoDiagnostico").value = datos[0];
                $get("TxtDiagnostico").value = datos[1];
            }
        }
        function Limpiar(IdCaja) {
            $get("HdfIdDiagnostico").value = "";
            if (IdCaja == 'TxtCodigoDiagnostico') {
                $get("TxtDiagnostico").value = "";
            }
            else
                $get("TxtCodigoDiagnostico").value = "";
        }
        function AgregarDiagnostico() {
            if ($get("HdfIdPsicologia").value != "") {
                PageMethods.HistoriaClinica_DiagnosticosInserta($get("HdfIdPsicologia").value, $get("HdfIdDiagnostico").value, $get("CbOrigen").value, $get("CbTipo").value, $get("TxtDiagnostico").value, $get("CbRelacion").value, HistoriaClinica_DiagnosticosInsertaOK, Errores);
            }
            else {
                Mensaje("Advertencia", "Debe abrir una Historia de Psicología.");
            }
        }
        function HistoriaClinica_DiagnosticosInsertaOK(Resultado) {
            if (Resultado == "")
                Mensaje("Advertencia", "No se puede crear el registro, por favor revise y vuelva a intentarlo.");
            else {
                Celdas = [CrearCelda($get("TxtCodigoDiagnostico").value, "left"), CrearCelda($get("TxtDiagnostico").value, "left"), CrearCelda($get("CbOrigen").value, "left"), CrearCelda($get("CbTipo").value, "left"), CrearCelda($get("CbRelacion").value, "left"), CrearCeldaEliminar("EliminarDiagnostico")];
                $get("TbDiagnosticos").getElementsByTagName('tbody')[0].insertBefore(CrearFila(Celdas), $get("TrDiagnosticos"));
                $.each($("#TrDiagnosticos input"), function (index, Control) {
                    Control.value = "";
                });
                $get("HdfIdDiagnostico").value = "";
            }
        }
        var FilaDiagnostico
        function EliminarDiagnostico(Boton) {
            if ($get("HdfEstado").value == "ABIERTA" || $get("HdfEstado").value == "CERRADA") {
                if (confirm("¿Desea eliminar este registro?")) {
                    Progreso(true);
                    FilaDiagnostico = Boton.parentNode.parentNode;
                    PageMethods.HistoriaClinica_DiagnosticosElimina(FilaDiagnostico.cells[0].innerText, $get("HdfIdPsicologia").value, HistoriaClinica_DiagnosticosEliminaOK, Errores);
                }
            }
            return false;
        }

        function HistoriaClinica_DiagnosticosEliminaOK(Resultado) {
            Progreso(false);
            if (Resultado > 0)
                $get("TbDiagnosticos").getElementsByTagName('tbody')[0].removeChild(FilaDiagnostico);

        }


        function ImprimirEvolucion() {
            if ($get("HdfIdPsicologia").value == "") {
                Mensaje("Fallo", "Para imprimir debe tener abierta una psicología, por favor revise y vuelva a intentarlo"); return false;
            }

            var IdEvoluciones = '';
            $.each($(".TrEvolucionSeleccionado"), function (index, Control) {
                if (Control.cells[4].children[0].checked) IdEvoluciones += Control.cells[0].innerHTML + "|";
            });

            if (IdEvoluciones != '') {
                IdEvoluciones = IdEvoluciones.substring(0, IdEvoluciones.length - 1);
                var Reporte = '../HistoriaClinica/Evoluciones.ashx?Id=' + $get("HdfIdPsicologia").value + "&Tipo=PsicologiaEvolucionReporteSelecciona&IdEvoluciones=" + IdEvoluciones; open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
            }
            else {
                Mensaje("Error", "Debe seleccionar una evolucion como minimo para la impresión");
            }
            return false;
            //var Reporte = '../HistoriaClinica/Evoluciones.ashx?Id=' + $get("HdfIdPsicologia").value + "&Tipo=PsicologiaEvolucionReporteSelecciona"; open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
        }



        var Fechavisible = false
        function AbrirCalendario() {
            if (!Fechavisible) {
                $("#TxtFechaAtencion").show();
                $get("TxtFechaAtencion").focus();
                Fechavisible = true;
            }
            else {
                $("#TxtFechaAtencion").hide();
                Fechavisible = false;
            }
        }
        function OcultarCalendario() {
            $("#TxtFechaAtencion").hide();
            PageMethods.AsignarFechaFiltro($get("TxtFechaAtencion").value, AsignarFechaFiltroOK);
            Fechavisible = false;
        }
        function AsignarFechaFiltroOK() {
            MostrarCantPaci();
        }
        function MostrarCantPaci() {
            PageMethods.ConsultaPaci(UsuarioDelSistema(), finllamada);
            if (timerID != undefined)
                clearTimeout(timerID);
            timerID = setTimeout("MostrarCantPaci()", 180000);
        }
        function finllamada(resultado) {
            $get("CantidadPacientes").innerHTML = resultado;
            $.ajax({
                type: "POST",
                data: "{ 'LoginProfesional': '" + UsuarioDelSistema() + "'}",
                url: "Psicologia.aspx/Prestador_RemisionesAtencionesPsicologias",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (Respuesta) {
                    $.each($(".EliminarFilas"), function (i, fila) {
                        $(fila).remove();
                    });
                    var Tipo;
                    $.each(JSON.parse(Respuesta.d).Datos, function (i, Turno) {
                        if (Turno.Telefonos == "")
                            Telefono = Turno.Celulares;
                        else
                            Telefono = Turno.Telefonos;
                        Celdas = [CrearCeldaSeleccionar("TipoAtencion"),
                                  CrearCelda(Turno.IdOrdenServicio, "center", "Invisible"),
                                  CrearCelda('', "center", "Invisible"),
                                  CrearCelda(Turno.FechaCreacion, "center"),
                                  CrearCelda(Turno.NumeroIdentificacion, "Left"),
                                  CrearCelda(Turno.Nombre, "Left"),
                                  CrearCelda(Turno.NombreEmpresa, "Left"),
                                  CrearCelda(Turno.IdProducto, "left", "Invisible"),
                                  CrearCelda(Turno.TipoIdentificacion, "center", "Invisible"),
                                  CrearCelda(Turno.FechaNacimiento, "center", "Invisible"),
                                  CrearCelda(Turno.Edad, "center", "Invisible"),
                                  CrearCelda(Turno.Cargo, "center", "Invisible"),
                                  CrearCelda(Turno.Eps, "center", "Invisible"),
                                  CrearCelda(Turno.Genero, "center", "Invisible"),
                                  CrearCelda(Turno.Direccion, "left", "Invisible"),
                                  CrearCelda(Telefono, "left", "Invisible"),
                                  CrearCelda(Turno.Celulares, "left", "Invisible"),
                                  CrearCelda(Turno.EstadoCivil, "left", "Invisible"),
                                  CrearCelda(Turno.NivelAcademico, "left", "Invisible"),
                                  CrearCelda(Turno.NombreAcompanante, "left", "Invisible"),
                                  CrearCelda(Turno.Parentesco, "left", "Invisible"),
                                  CrearCelda(Turno.TelefonoAcudiente, "left", "Invisible")];
                        $get("TbTurnos").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "EliminarFilas"));
                    });
                },
                error: function (Respuesta) { Mensaje("Error", JSON.parse(Respuesta.responseText).Message) }
            });
        }
        var DatoTurno;
        function TipoAtencion(datos) {
            Progreso(false);
            $get("HdfIdOrdenServicioControl").value = "";
            $find("MpePnEvolucion").show();
            DatoTurno = datos;
            return false;
        }

        function AtencionControl() {
            $find("MpePnEvolucion").hide();
            datos = DatoTurno.parentNode.parentNode.cells;
            NoIdentificacion = datos[4].innerText;
            $get("HdfIdOrdenServicioControl").value = datos[1].innerText
            BuscarPsicologiaTipoAtencion(NoIdentificacion);
        }

        function BuscarPsicologiaTipoAtencion(NoId) {
            $find("CpPnGvTurnos")._doClose();
            Progreso(true);
            $.ajax({
                type: "POST",
                data: "{ 'NumeroIdentificacion': '" + NoId +
                  "'}",
                url: "Psicologia.aspx/HistoriaClinica_PsicologiasBuscarTipoAtencion",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (Respuesta) {
                    Progreso(false);
                    Respuesta = JSON.parse(Respuesta.d);
                    if (Respuesta.Datos.length > 0) {
                        Buscar(Respuesta.Datos[0].IdPsicologia);
                        AsignarIdPsicologiaEstado();
                    }
                    else {
                        Mensaje("Informacion", "La búsqueda no arrojó ningún resultado.");
                    }
                },
                error: function (Respuesta) { Progreso(false); Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
            });
            return false;
        }


        function AtencionPrimeraVez() {
            $find("MpePnEvolucion").hide();
            AsignarTurno(DatoTurno);
            return false;
        }


        function AsignarTurno(datos) {
            Nuevo();
            Progreso(true);
            Desbloquear();
            $find("CpPnGvTurnos")._doClose();
            datos = datos.parentNode.parentNode.cells;
            $get("HdfIdOrdenServicio").value = datos[1].innerText;
            $get("TxtNumeroIdentificacion").value = datos[4].innerText;
            $get("TxtNombre").value = datos[5].innerText;
            $get("TxtEmpresa").value = datos[6].innerText;
            $get("TxtTipoIdentificacion").value = datos[8].innerText;
            $get("TxtFechaNacimiento").value = datos[9].innerText;
            $get("TxtEdad").value = datos[10].innerText;
            $get("TxtProfesion").value = datos[11].innerText;
            $get("HdfGenero").value = datos[13].innerText;
            $get("TxtGenero").value = datos[13].innerText;
            $get("TxtDireccion").value = datos[14].innerText;
            $get("TxtTelefonos").value = datos[15].innerText;
            $get("TxtCelulares").value = datos[16].innerText;
            $get("TxtEstadoCivil").value = datos[17].innerText;
            $get("TxtNivelAcademico").value = datos[18].innerText;
            $get("TxtNombreAcudiente").value = datos[19].innerText;
            $get("TxtParentesco").value = datos[20].innerText;
            $get("TxtTelefonoAcudiente").value = datos[21].innerText;
            PageMethods.HistoriaClinica_PsicologiasInserta($get("TxtNumeroIdentificacion").value, $get("HdfMunicipio").value, $get("HdfIdOrdenServicio").value, UsuarioDelSistema(), HistoriaClinica_PsicologiasInsertaOK, Errores);
        }
        function HistoriaClinica_PsicologiasInsertaOK(Resultado) {
            $find("CpPnGvTurnos")._doClose();
            Progreso(false);
            Resultado = Resultado.split("|");
            if (Resultado[0] == "0")
                Mensaje("Advertencia", "No se puedo crear la Historia de Psicología, por favor revise y vuelva a intentarlo.");
            else {
                $get("HdfIdPsicologia").value = Resultado[1];
                $get("HdfEstado").value = "ABIERTA";
                AsignarIdPsicologiaEstado();
            }
            MostrarCantPaci();
        }


        //Evoluciones

        function ProximoSeguimientoEvolucion() {
            return $("#TxtFechaEvolucion").val() + " " + $("#CbHora").val() + ":" + $("#CbMinutos").val() + " " + $("#CbAmPm").val();
        }

        function GuardarEvolucion() {
            $(".ErrorValidacion").removeClass("ErrorValidacion");
            if ($get("HdfIdPsicologia").value != "") {

                Validar($get("TxtEvolucion"));
                Validar($get("TxtFechaEvolucion"));
                Validar($get("CbHora"));
                Validar($get("CbMinutos"));
                Validar($get("CbAmPm"));


                if (!$(".ErrorValidacion").length > 0) {
                    PageMethods.HistoriaClinica_PsicologiasEvolucionesInserta($get('HdfIdPsicologia').value
                    , $get("TxtEvolucion").value, ProximoSeguimientoEvolucion(), UsuarioDelSistema()
                    , $get("HdfIdOrdenServicioControl").value
                    , HistoriaClinica_PsicologiasEvolucionesInsertaOK, Errores);
                }
            }
            else { Mensaje("Fallo", "Para Guardar debe tener abierta una atención, por favor revise y vuelva a intentarlo"); }
            return false;
        }

        function HistoriaClinica_PsicologiasEvolucionesInsertaOK(Resultado) {
            var Resultado = JSON.parse(Resultado);
            if (Resultado.Datos.length == 0) {
                Mensaje("Advertencia", "No se puede crear el registro, por favor revise y vuelva a intentarlo");
            } else {
                document.getElementById("HdfIdOrdenServicioControl").value = "";
                Celdas = [
                 CrearCelda(Resultado.Datos[0].IdEvolucion, "left", "Invisible"),
                 CrearCelda(ProximoSeguimientoEvolucion(), "center"),
                 CrearCelda(UsuarioDelSistema(), "center"),
                 CrearCelda($get("TxtEvolucion").value, "left"),
                 CrearCelda('<input type="checkbox" />', "center")];
                $get("TbEvolucionFecha").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "TrEvolucionSeleccionado"));

                $.each($("#p1 input,#p1 select,#p1 textarea"), function (Index, Control) {
                    Control.value = "";
                });

                OcultarCalendario();
            }
        }
        //Evoluciones


        //Ordenes Medicas INICIO

        //Medicamentos
        function AsignarIdMedicamento(source, eventArgs) {
            var a = eventArgs.get_value()
            $get("HdfIdMedicamento").value = a;
        }

        function NuevaOrdenMedica() {
            var NoOredenMedica;
            NoOredenMedica = ParsearNumero($('#CbNumeroOrdenMedicamento')[0][$('#CbNumeroOrdenMedicamento')[0].length - 1].value) + 1
            $('#CbNumeroOrdenMedicamento').append("<option value=" + NoOredenMedica + ">" + NoOredenMedica + "</option>");
            $('#CbNumeroOrdenMedicamento').val(NoOredenMedica)
            $.each($("#TbMedicamentos tr"), function (i, fila) {
                if (fila.rowIndex != 0)
                    $(fila).remove()
            });
        }

        function GuardarMedicamento() {
            $(".ErrorValidacion").removeClass("ErrorValidacion");
            if ($get("HdfIdPsicologia").value != "") {
                Validar($get("TxtMedicamento"));
                Validar($get("TxtCantidadMed"));
                if (!$(".ErrorValidacion").length > 0) {
                    PageMethods.HistoriaClinica_PsicologiasOrdenMedicamentoInserta($get("HdfIdPsicologia").value, $get("HdfIdMedicamento").value, $get("TxtPosologia").value
                    , $get("TxtCantidadMed").value, $get("TxtMedicamento").value, $get("CbNumeroOrdenMedicamento").value
                    , HistoriaClinica_PsicologiasOrdenMedicamentoInsertaOK, Errores)
                }
            }
        }
        function HistoriaClinica_PsicologiasOrdenMedicamentoInsertaOK(Resultado) {
            Resultado = Resultado.split("|")
            if (Resultado[0] == "0")
                Mensaje("Advertencia", "No se puede crear el registro, por favor revise y vuelva a intentarlo");
            else {
                Celdas = [CrearCelda(Resultado[1], "left", "Invisible"),
                          CrearCelda($get("TxtMedicamento").value, "left"),
                          CrearCelda($get("TxtCantidadMed").value, "center"),
                          CrearCelda($get("TxtPosologia").value, "left"),
                          CrearCeldaEliminar("EliminarMedicamento")];
                $get("TbMedicamentos").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "EliminarMedicamento"));
                $.each($("#TbMedicamento input"), function (index, Control) {
                    Control.value = "";
                });
            }
        }

        function Posologia() {
            $get('TxtPosologia').value = $get('TxtCantidadPosologia').value + " cada " + $get('TxtDosis').value + " horas durante " + $get('TxtDias').value + " días.";
            $get('TxtCantidadMed').value = Math.round(24 / $get('TxtDosis').value * $get('TxtCantidadPosologia').value * $get('TxtDias').value);
        }

        function CargarMedicamentos() {
            PageMethods.HistoriaClinica_PsicologiasOrdenMedicamentoSelecciona($get('HdfIdPsicologia').value, $get("CbNumeroOrdenMedicamento").value, HistoriaClinica_PsicologiasOrdenMedicamentoSeleccionaOK, Errores)
        }
        function HistoriaClinica_PsicologiasOrdenMedicamentoSeleccionaOK(Resultado) {
            $.each($("#TbMedicamentos tr"), function (i, fila) {
                if (fila.rowIndex != 0)
                    $(fila).remove()
            });
            if (Resultado != "") {
                Medicamentos = Resultado.split("~");
                for (var i in Medicamentos) {
                    DatoMedicamentos = Medicamentos[i].split("|");
                    Celdas = [CrearCelda(DatoMedicamentos[0], "left", "Invisible"),
                              CrearCelda(DatoMedicamentos[1], "left"),
                              CrearCelda(DatoMedicamentos[2], "center"),
                              CrearCelda(DatoMedicamentos[3], "left"),
                              CrearCeldaEliminar("EliminarMedicamento")];
                    $get("TbMedicamentos").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "EliminarMedicamento"));
                }
                $('#CbNumeroOrdenMedicamento').val(Medicamentos[0].split("|")[4])
            }
        }

        function EliminarMedicamento(Boton) {
            swal({ title: "Solo Queremos Verificar", text: "¿Estás seguro que deseas eliminar este registro?", type: "warning", showCancelButton: true, confirmButtonColor: "#0098DA", confirmButtonText: "Si, por favor.", cancelButtonText: "No, gracias.", closeOnConfirm: true },
                 function () {
                     Progreso(true);
                     var FilaMedicamento = Boton.parentNode.parentNode;
                     $.ajax({
                         type: "POST",
                         data: "{ 'IdOrdenMedicamento': '" + FilaMedicamento.cells[0].innerText +
                               "'}",
                         url: "Psicologia.aspx/HistoriaClinica_PsicologiasOrdenMedicamentoElimina",
                         contentType: "application/json; charset=utf-8",
                         dataType: "json",
                         success: function (Respuesta) {
                             Progreso(false);
                             var Respuesta = JSON.parse(Respuesta.d);

                             if (Respuesta > 0) {
                                 $get("TbMedicamentos").getElementsByTagName('tbody')[0].removeChild(FilaMedicamento);
                                 NotificacionEmergente($get("TbMedicamentos"), "FondoVerde", "Eliminado con éxito");
                             }
                         },
                         error: function (Respuesta) { Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                     });
                 });
            return false;
        }

        function ImprimeOrdenMedicamento() {
            if ($get("HdfIdPsicologia").value == "") {
                Mensaje("Fallo", "Para imprimir debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo"); return false;
            }
            else {
                if ($get("TbMedicamentos").childNodes[1].rows.length > 1) {
                    var Reporte = '../HistoriaClinica/OrdenMedicamento.ashx?Id=' + $get("HdfIdPsicologia").value + '&V=' + $get('CbNumeroOrdenMedicamento').value + '&T=NA' + '&rd=' + Math.random(); open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
                }
                else { Mensaje("Fallo", "Aun no se han agregado medicamentos"); return false; }
            }
        }



        //Servicios
        function AsignarIdServicio(source, eventArgs) {
            $get("HdfIdServicio").value = eventArgs.get_value();
        }


        function NuevaOrdenServicio() {
            var NoOredenServicio;
            NoOredenServicio = ParsearNumero($('#CbNumeroOrdenServicio')[0][$('#CbNumeroOrdenServicio')[0].length - 1].value) + 1
            $('#CbNumeroOrdenServicio').append("<option value=" + NoOredenServicio + ">" + NoOredenServicio + "</option>");
            $('#CbNumeroOrdenServicio').val(NoOredenServicio)
            $.each($("#TbServicios tr"), function (i, fila) {
                if (fila.rowIndex != 0)
                    $(fila).remove()
            });
        }

        function GuardarServicio() {
            $(".ErrorValidacion").removeClass("ErrorValidacion");
            if ($get("HdfIdPsicologia").value != "") {
                Validar($get("TxtServicio"));
                Validar($get("TxtCantidadServicio"));
                if (!$(".ErrorValidacion").length > 0)
                    PageMethods.HistoriaClinica_PsicologiasOrdenesServiciosInserta($get("HdfIdPsicologia").value, $get("HdfIdServicio").value, $get("TxtCantidadServicio").value, $get("TxtServicio").value, $get("CbNumeroOrdenServicio").value, $get("TxtObservacionesServicios").value,
                     HistoriaClinica_PsicologiasOrdenesServiciosInsertaOK, Errores)
            }
        }
        function HistoriaClinica_PsicologiasOrdenesServiciosInsertaOK(Resultado) {
            Resultado = Resultado.split("|")
            if (Resultado[0] == "0")
                Mensaje("Advertencia", "No se puede crear el registro, por favor revise y vuelva a intentarlo");
            else {
                Celdas = [CrearCelda(Resultado[1], "left", "Invisible"),
                          CrearCelda($get("TxtServicio").value, "left"),
                          CrearCelda($get("TxtObservacionesServicios").value, "left"),
                          CrearCelda($get("TxtCantidadServicio").value, "center"),
                          CrearCeldaEliminar("EliminarOrdenServicio")];
                $get("TbServicios").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "EliminarOrdenServicio"));
                $.each($("#TbServicio input"), function (index, Control) {
                    Control.value = "";
                });

            }
        }

        function CargarServicios() {
            PageMethods.HistoriaClinica_PsicologiasOrdenesServiciosSelecciona($get('HdfIdPsicologia').value, $get("CbNumeroOrdenServicio").value, HistoriaClinica_PsicologiasOrdenesServiciosSeleccionaOK, Errores)
        }
        function HistoriaClinica_PsicologiasOrdenesServiciosSeleccionaOK(Resultado) {
            $.each($("#TbServicios tr"), function (i, fila) {
                if (fila.rowIndex != 0)
                    $(fila).remove()
            });
            if (Resultado != "") {
                Servicios = Resultado.split("~");
                for (var i in Servicios) {
                    DatoServicios = Servicios[i].split("|");
                    Celdas = [CrearCelda(DatoServicios[0], "left", "Invisible"),
                              CrearCelda(DatoServicios[1], "left"),
                              CrearCelda(DatoServicios[2], "left"),
                              CrearCelda(DatoServicios[3], "center"),
                              CrearCeldaEliminar("EliminarOrdenServicio")];
                    $get("TbServicios").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "EliminarOrdenServicio"));
                }
                $('#CbNumeroOrdenServicio').val(Servicios[0].split("|")[4])
            }
        }

        function EliminarOrdenServicio(Boton) {
            swal({ title: "Solo Queremos Verificar", text: "¿Estás seguro que deseas eliminar este registro?", type: "warning", showCancelButton: true, confirmButtonColor: "#0098DA", confirmButtonText: "Si, por favor.", cancelButtonText: "No, gracias.", closeOnConfirm: true },
                 function () {
                     Progreso(true);
                     var FilaOrdenServicio = Boton.parentNode.parentNode;
                     $.ajax({
                         type: "POST",
                         data: "{ 'IdOrdenServicio': '" + FilaOrdenServicio.cells[0].innerText +
                               "'}",
                         url: "Psicologia.aspx/HistoriaClinica_PsicologiasOrdenesServiciosElimina",
                         contentType: "application/json; charset=utf-8",
                         dataType: "json",
                         success: function (Respuesta) {
                             Progreso(false);
                             var Respuesta = JSON.parse(Respuesta.d);

                             if (Respuesta > 0) {
                                 $get("TbServicios").getElementsByTagName('tbody')[0].removeChild(FilaOrdenServicio);
                                 NotificacionEmergente($get("TbServicios"), "FondoVerde", "Eliminado con éxito");
                             }
                         },
                         error: function (Respuesta) { Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                     });
                 });
            return false;
        }

        function ImprimeOrdenServicio() {
            if ($get("HdfIdPsicologia").value == "") {
                Mensaje("Fallo", "Para imprimir debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo"); return false;
            }
            else {
                if ($get("TbServicios").childNodes[1].rows.length > 1) {
                    var Reporte = '../HistoriaClinica/OrdenesServicios.ashx?Id=' + $get("HdfIdPsicologia").value + '&V=' + $get('CbNumeroOrdenServicio').value + '&T=NA' + '&rd=' + Math.random(); open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
                }
                else { Mensaje("Fallo", "Aun no se han agregado Servicios"); return false; }
            }
        }

        //Remisiones
        function AsignarCodigoEspecialidad(source, eventArgs) {
            $get("HdfCodigoEspecialidad").value = eventArgs.get_value();
        }


        function NuevaOrdenRemision() {
            var NoOredenRemision;
            NoOredenRemision = ParsearNumero($('#CbNumeroOrdenRemision')[0][$('#CbNumeroOrdenRemision')[0].length - 1].value) + 1
            $('#CbNumeroOrdenRemision').append("<option value=" + NoOredenRemision + ">" + NoOredenRemision + "</option>");
            $('#CbNumeroOrdenRemision').val(NoOredenRemision)
            $.each($("#TbOrdenRemisiones tr"), function (i, fila) {
                if (fila.rowIndex != 0)
                    $(fila).remove()
            });
        }

        function GuardarOrdenRemision() {
            $(".ErrorValidacion").removeClass("ErrorValidacion");
            if ($get("HdfIdPsicologia").value != "") {
                Validar($get("TxtEspecialidad"));
                if (!$(".ErrorValidacion").length > 0)
                    PageMethods.HistoriaClinica_PsicologiasOrdenesRemisionesInserta($get("HdfIdPsicologia").value, $get("HdfCodigoEspecialidad").value, $get("TxtEspecialidad").value
                     , $get("CbNumeroOrdenRemision").value, $get("TxtMotivoRemision").value
                     , HistoriaClinica_PsicologiasOrdenesRemisionesInsertaOK, Errores)
            }
        }
        function HistoriaClinica_PsicologiasOrdenesRemisionesInsertaOK(Resultado) {
            Resultado = Resultado.split("|")
            if (Resultado[0] == "0")
                Mensaje("Advertencia", "No se puede crear el registro, por favor revise y vuelva a intentarlo");
            else {
                Celdas = [CrearCelda(Resultado[1], "left", "Invisible"),
                          CrearCelda($get("TxtEspecialidad").value, "left"),
                          CrearCelda($get("TxtMotivoRemision").value, "left"),
                          CrearCeldaEliminar("EliminarOrdenRemision")];
                $get("TbOrdenRemisiones").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "EliminarOrdenRemision"));
                $.each($("#TbOrdenRemision input"), function (index, Control) {
                    Control.value = "";
                });

            }
        }

        function CargarRemisiones() {
            PageMethods.HistoriaClinica_PsicologiasOrdenesRemisionesSelecciona($get('HdfIdPsicologia').value, $get("CbNumeroOrdenRemision").value, HistoriaClinica_PsicologiasOrdenesRemisionesSeleccionaOK, Errores)
        }
        function HistoriaClinica_PsicologiasOrdenesRemisionesSeleccionaOK(Resultado) {
            $.each($("#TbOrdenRemisiones tr"), function (i, fila) {
                if (fila.rowIndex != 0)
                    $(fila).remove()
            });
            if (Resultado != "") {

                Remisiones = Resultado.split("~");
                for (var i in Remisiones) {
                    DatoRemisiones = Remisiones[i].split("|");
                    Celdas = [CrearCelda(DatoRemisiones[0], "left", "Invisible"),
                              CrearCelda(DatoRemisiones[1], "left"),
                              CrearCelda(DatoRemisiones[2], "left"),
                              CrearCeldaEliminar("EliminarOrdenRemision")];
                    $get("TbOrdenRemisiones").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "EliminarOrdenRemision"));
                }
                $('#CbNumeroOrdenRemision').val(Remisiones[0].split("|")[3])
            }
        }

        function EliminarOrdenRemision(Boton) {
            swal({ title: "Solo Queremos Verificar", text: "¿Estás seguro que deseas eliminar este registro?", type: "warning", showCancelButton: true, confirmButtonColor: "#0098DA", confirmButtonText: "Si, por favor.", cancelButtonText: "No, gracias.", closeOnConfirm: true },
                 function () {
                     Progreso(true);
                     var FilaRemision = Boton.parentNode.parentNode;
                     $.ajax({
                         type: "POST",
                         data: "{ 'IdOrdenRemision': '" + FilaRemision.cells[0].innerText +
                               "'}",
                         url: "Psicologia.aspx/HistoriaClinica_PsicologiasOrdenesRemisionesElimina",
                         contentType: "application/json; charset=utf-8",
                         dataType: "json",
                         success: function (Respuesta) {
                             Progreso(false);
                             var Respuesta = JSON.parse(Respuesta.d);

                             if (Respuesta > 0) {
                                 $get("TbOrdenRemisiones").getElementsByTagName('tbody')[0].removeChild(FilaRemision);
                                 NotificacionEmergente($get("TbOrdenRemisiones"), "FondoVerde", "Eliminado con éxito");
                             }
                         },
                         error: function (Respuesta) { Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                     });
                 });
            return false;
        }

        function ImprimeOrdenRemision() {
            if ($get("HdfIdPsicologia").value == "") {
                Mensaje("Fallo", "Para imprimir debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo"); return false;
            }
            else {
                if ($get("TbOrdenRemisiones").childNodes[1].rows.length > 1) {
                    var Reporte = '../HistoriaClinica/OrdenesRemisiones.ashx?Id=' + $get("HdfIdPsicologia").value + '&V=' + $get('CbNumeroOrdenRemision').value + '&T=NA' + '&rd=' + Math.random(); open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
                }
                else { Mensaje("Fallo", "Aun no se han agregado Remisiones"); return false; }
            }
        }


        //Incapacidades
        function CalcularDiasIncapacidad(Input, Tipo) {
            var FechaInicial = "";
            var FechaFinal = "";
            var Dias = "";
            if (Input.value != "") {

                if ($get("TxtFechaInicial").value != "") {
                    FechaInicial = moment($get("TxtFechaInicial").value, 'DD/MM/YYYY', true).format()
                }

                if ($get("TxtFechaFinal").value != "") {
                    FechaFinal = moment($get("TxtFechaFinal").value, 'DD/MM/YYYY', true).format()
                }

                if ($get("TxtDiasDeIncapacidad").value != "") {
                    Dias = $get("TxtDiasDeIncapacidad").value;
                }

                if ($get("TxtFechaInicial").value != "") {
                    if (Tipo == "Final") {
                        if (moment(FechaFinal).diff(FechaInicial, "days") >= 0) {
                            $get("TxtDiasDeIncapacidad").value = moment(FechaFinal).diff(FechaInicial, "days") + 1;
                        } else {
                            $get("TxtFechaFinal").value = "";
                            $get("TxtDiasDeIncapacidad").value = "";
                            NotificacionEmergente($get("TxtFechaFinal"), "FondoRojo", "La fecha en la que termina la incapacidad debe ser mayor o igual a <b>" + $get("TxtFechaInicial").value + "</b>.");
                        }
                    } else if (Tipo == "Dias") {
                        $get("TxtFechaFinal").value = moment(FechaInicial).add(parseInt(Dias), 'days').format("DD/MM/YYYY");
                    }
                }
            }
            return false;
        }

        function NuevaOrdenIncapacidad() {
            var NoOrdenIncapacidad;
            NoOrdenIncapacidad = ParsearNumero($('#CbNumeroOrdenIncapacidad')[0][$('#CbNumeroOrdenIncapacidad')[0].length - 1].value) + 1;
            $('#CbNumeroOrdenIncapacidad').append("<option value=" + NoOrdenIncapacidad + ">" + NoOrdenIncapacidad + "</option>");
            $('#CbNumeroOrdenIncapacidad').val(NoOrdenIncapacidad);
            $.each($("#TbOrdenIncapacidad tr"), function (i, fila) {
                if (fila.rowIndex != 0)
                    $(fila).remove();
            });
        }

        function GuardarOrdenIncapacidad() {
            $(".ErrorValidacion").removeClass("ErrorValidacion");
            if ($get("HdfIdPsicologia").value != "") {
                Validar($get("TxtMotivoIncapacidad"), false, 'ErrorValidacion');
                Validar($get("TxtDiasDeIncapacidad"), false, 'ErrorValidacion');
                if (!$(".ErrorValidacion").length > 0) {
                    Progreso(true);
                    PageMethods.HistoriaClinica_PsicologiasOrdenesIncapacidadesInserta($get("HdfIdPsicologia").value, $get("TxtMotivoIncapacidad").value
                     , $get("TxtDiasDeIncapacidad").value, $get("CbTipoIncapacidad").value, $get("CbNumeroOrdenIncapacidad").value
                     , $get("TxtFechaInicial").value, $get("TxtFechaFinal").value
                     , HistoriaClinica_PsicologiasOrdenesIncapacidadesInsertaOK, Errores);
                }
            }
        }
        function HistoriaClinica_PsicologiasOrdenesIncapacidadesInsertaOK(Resultado) {
            Progreso(false);
            Resultado = Resultado.split("|")
            if (Resultado[0] == "0")
                Mensaje("Advertencia", "No se puede crear el registro, por favor revise y vuelva a intentarlo");
            else {
                Celdas = [CrearCelda(Resultado[1], "left", "Invisible"),
                          CrearCelda($get("TxtMotivoIncapacidad").value, "left"),
                          CrearCelda($get("TxtDiasDeIncapacidad").value, "center"),
                          CrearCelda($get("CbTipoIncapacidad").value, "left"),
                          CrearCeldaEliminar("EliminarOrdenIncapacidad")];
                $get("TbOrdenIncapacidad").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "Eliminar"));
                $get("TxtMotivoIncapacidad").value = "";
                $get("TxtDiasDeIncapacidad").value = "";
                $get("CbTipoIncapacidad").value = "";
                $get("TxtFechaInicial").value = "";
                $get("TxtFechaFinal").value = "";
            }
        }

        function CargarOrdenIncapacidad() {
            Progreso(true);
            PageMethods.HistoriaClinica_PsicologiasOrdenesIncapacidadesSelecciona($get('HdfIdPsicologia').value, $get("CbNumeroOrdenIncapacidad").value
             , HistoriaClinica_PsicologiasOrdenesIncapacidadesSeleccionaOK, Errores)
        }
        function HistoriaClinica_PsicologiasOrdenesIncapacidadesSeleccionaOK(R) {
            $("#TbOrdenIncapacidad tbody").children('tr:not(:first)').remove();
            var Filas = 0;
            $.each(JSON.parse(R).Datos, function (i, Fila) {
                Celdas = [CrearCelda(Fila.IdOrdenIncapacidad, "left", "Invisible"),
                          CrearCelda(Fila.MotivoIncapacidad, "left"),
                          CrearCelda(Fila.DiasIncapacidad, "center"),
                          CrearCelda(Fila.Tipo, "left"),
                          CrearCeldaEliminar("EliminarOrdenIncapacidad")];
                $get("TbOrdenIncapacidad").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "EliminarOrdenIncapacidad"));
                Filas = Fila.Numero;
            });
            if ($get('CbNumeroOrdenIncapacidad').options.length < Filas) {
                $("#CbNumeroOrdenIncapacidad").children('option').remove();
                for (i = 1; i <= ParsearNumero(Filas) ; i++)
                    $('#CbNumeroOrdenIncapacidad').append("<option value=" + i + ">" + i + "</option>");
            }
            $('#CbNumeroOrdenIncapacidad').val(Filas)
            Progreso(false);
        }

        function EliminarOrdenIncapacidad(Boton) {
            swal({ title: "Solo Queremos Verificar", text: "¿Estás seguro que deseas eliminar este registro?", type: "warning", showCancelButton: true, confirmButtonColor: "#0098DA", confirmButtonText: "Si, por favor.", cancelButtonText: "No, gracias.", closeOnConfirm: true },
                 function () {
                     Progreso(true);
                     var FilaOrdenIncapacidad = Boton.parentNode.parentNode;
                     $.ajax({
                         type: "POST",
                         data: "{ 'IdOrdenIncapacidad': '" + FilaOrdenIncapacidad.cells[0].innerText +
                               "'}",
                         url: "Psicologia.aspx/HistoriaClinica_PsicologiasOrdenesIncapacidadesElimina",
                         contentType: "application/json; charset=utf-8",
                         dataType: "json",
                         success: function (Respuesta) {
                             Progreso(false);
                             var Respuesta = JSON.parse(Respuesta.d);

                             if (Respuesta > 0) {
                                 $get("TbOrdenIncapacidad").getElementsByTagName('tbody')[0].removeChild(FilaOrdenIncapacidad);
                                 NotificacionEmergente($get("TbOrdenIncapacidad"), "FondoVerde", "Eliminado con éxito");
                             }
                         },
                         error: function (Respuesta) { Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                     });
                 });
            return false;
        }

        function ImprimeOrdenIncapacidades() {
            if ($get("HdfIdPsicologia").value == "") {
                Mensaje("Fallo", "Para imprimir debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo");
                return false;
            }
            else {
                if ($get("TbOrdenIncapacidad").childNodes[1].rows.length > 1) {
                    var Reporte = '../HistoriaClinica/OrdenesIncapacidades.ashx?Id=' + $get("HdfIdPsicologia").value + '&V=' + $get('CbNumeroOrdenIncapacidad').value + '&T=NA'; open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes');
                    return false;
                }
                else { Mensaje("Fallo", "Aun no se han agregado Incapacidades"); return false; }
            }
        }

        //Certificaciones
        function NuevaOrdenCertificacion() {
            var NoOrdenCertificacion;
            NoOrdenCertificacion = ParsearNumero($('#CbNumeroOrdenCertificacion')[0][$('#CbNumeroOrdenCertificacion')[0].length - 1].value) + 1;
            $('#CbNumeroOrdenCertificacion').append("<option value=" + NoOrdenCertificacion + ">" + NoOrdenCertificacion + "</option>");
            $('#CbNumeroOrdenCertificacion').val(NoOrdenCertificacion);
            $('#TxtDescripcionCertificacion').val("");
            $('#HdfIdOrdenCertificacion').val("");
        }

        function GuardarOrdenCertificacion() {
            if ($get("HdfEstado").value == "ABIERTA" || $get("HdfEstado").value == "CERRADA") {
                Progreso(true);
                $.ajax({
                    type: "POST",
                    data: "{ 'IdOrdenCertificacion': '" + $("#HdfIdOrdenCertificacion").val() +
                          "','IdPsicologia': '" + $("#HdfIdPsicologia").val() +
                          "','DescripcionCertificacion': '" + CKEDITOR.instances['TxtDescripcionCertificacion'].getData() +
                          "','Numero': '" + $("#CbNumeroOrdenCertificacion").val() +
                          "'}",
                    url: "Psicologia.aspx/HistoriaClinica_PsicologiasOrdenesCertificacionInsertaActualiza",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (Respuesta) {
                        Progreso(false);
                        Datos = Respuesta.d.split("|");
                        if (parseInt(Datos[0]) > 0) {
                            Mensaje("Informacion", "La orden de certificacion se ha guardado correctamente.");
                            $("#HdfIdOrdenCertificacion").val(Datos[1]);
                        }
                    },
                    error: function (Respuesta) { Progreso(false); Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                });
            }
            else {
                Mensaje("Advertencia", "No se pueden guardar las ordenes de certificaciones con estado " + $get("HdfEstado").value + ".");
            }
        }

        function CargarOrdenCertificacion() {
            Progreso(true);
            PageMethods.HistoriaClinica_PsicologiasOrdenesCertificacionSelecciona($get('HdfIdPsicologia').value, $get("CbNumeroOrdenCertificacion").value, HistoriaClinica_PsicologiasOrdenesCertificacionSeleccionaOK, Errores)
        }

        function HistoriaClinica_PsicologiasOrdenesCertificacionSeleccionaOK(R) {
            var Filas = 0;
            $.each(JSON.parse(R).Datos, function (i, Fila) {
                document.getElementById("HdfIdOrdenCertificacion").value = Fila.IdOrdenCertificacion
                CKEDITOR.instances['TxtDescripcionCertificacion'].setData(Fila.DescripcionCertificacion);
                Filas = Fila.Numero;
            });
            if ($get('CbNumeroOrdenCertificacion').options.length < Filas) {
                $("#CbNumeroOrdenCertificacion").children('option').remove();
                for (i = 1; i <= ParsearNumero(Filas) ; i++)
                    $('#CbNumeroOrdenCertificacion').append("<option value=" + i + ">" + i + "</option>");
            }
            $('#CbNumeroOrdenCertificacion').val(Filas);
            Progreso(false);
        }

        function ImprimeOrdenCertificacion() {
            if ($get("HdfIdPsicologia").value == "") {
                Mensaje("Fallo", "Para imprimir debe tener abierta una atención, por favor revise y vuelva a intentarlo");
                return false;
            }
            else {
                var Reporte = '../HistoriaClinica/OrdenesCertificacion.ashx?Id=' + $get("HdfIdPsicologia").value + '&V=' + $get('CbNumeroOrdenCertificacion').value + '&T=NA'; open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes');
                return false;
            }
        }


        //Ordenes Medicas FIN



        //Documentos Externos INICIO


        function VerExamen(Boton) {
            Datos = Boton.parentNode.parentNode;
            NombreImagen = (Boton.src).substring((Boton.src).lastIndexOf("/") + 1);
            var Reporte = '../HistoriaClinica/ExamenesDiagnosticos/' + Datos.cells[0].innerHTML + "." + NombreImagen.substring(0, NombreImagen.indexOf(".")) + '?rd=' + Math.random();
            open(Reporte, 'Tik', 'top=0,left=10,width=970,height=700,status=yes,resizable=no,scrollbars=yes');
            return false;
        }

        function CargaCompletaArchivo(sender, args) {
            Progreso(false);
            $get("TxtNombreExamen").value = '';
            $get("TxtResultado").value = '';
            //Limpiar Caché
            var fileInputElement = sender.get_inputFile();
            fileInputElement.value = "";
            if ($get("TxtNumeroIdentificacion").value != '')
                LlenarTablaExamenDiagnostico();
            return false;
        }

        function ErrorCarga(sender, args) {
            Progreso(false);
            //Limpiar Caché
            var fileInputElement = sender.get_inputFile();
            fileInputElement.value = "";
            Mensaje("Advertencia", args.get_errorMessage());
        }


        function IniciaCarga(sender, args) {
            $(".ErrorValidacion").removeClass("ErrorValidacion");
            if ($get("TxtNombreExamen").value == "") {
                Validar($get("TxtNombreExamen"));
                var err = new Error();
                err.name = "Advertencia";
                err.message = "Advertencia", "Debe escribir un nombre para el Documento Externo";
                throw (err);
                return false;

            }
            else if ($get("TxtNumeroIdentificacion").value == "") {
                var err = new Error();
                err.name = "Advertencia";
                err.message = "Advertencia", "Para Guardar un Documento Externo debe primero buscar un paciente";
                throw (err);
                return false;
            }
            else {
                Progreso(true);
            }

            Progreso(true);


            var fileName = args.get_fileName();
            var fileExt = fileName.substring(fileName.lastIndexOf(".") + 1);
            var Categoria = "Imagenes, Documentos";
            var ExtensionesCategoria = "";
            $.each(ArchivosPermitidosBiofile, function (i, Documento) {
                if (Categoria.includes(Documento.Categoria)) {
                    if (!(ExtensionesCategoria.includes(Documento.ExtensionesPermitidas))) {
                        ExtensionesCategoria = ExtensionesCategoria + Documento.ExtensionesPermitidas
                    }

                }
            })


            $.each(ArchivosPermitidosBiofile, function (i, Documento) {
                if (Categoria.includes(Documento.Categoria)) {

                    if (!(ExtensionesCategoria.includes(fileExt))) {
                        Progreso(false);
                        var err = new Error();
                        err.name = "Advertencia";
                        err.message = "Archivo no permitido los archivos permitidos son: <b> " + ExtensionesCategoria + "</b> ";
                        Errores;
                        throw (err);
                        return false;
                    }
                }

            })

        }

        function LlenarTablaExamenDiagnostico() {
            Progreso(true);
            $.ajax({
                type: "POST",
                data: "{ 'NumeroIdentificacion': '" + $get("TxtNumeroIdentificacion").value +
                    "','IdOrdenServicio': '" + $get("HdfIdOrdenServicio").value +
                    "'}",
                url: NombreFormulario() + "/HistoriaClinica_DocumentosExternosSelecciona",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (Respuesta) {
                    Progreso(false);
                    Respuesta = JSON.parse(Respuesta.d);
                    $("#TbExamenes tbody").children('tr:not(:first)').remove();
                    if (Respuesta.Datos.length > 0)
                        $.each(Respuesta.Datos, function (i, Dato) {
                            Celdas = [CrearCelda(Dato.IdExamenDiagnostico, "left", "Invisible"),
                                      CrearCelda(Dato.NombreProducto, "left"),
                                      CrearCelda(Dato.Resultado, "left"),
                                      CrearCelda(Dato.FechaCreacion, "center"),
                                      CrearCelda(Dato.UsuarioCreacion, "center"),
                                      CrearCeldaImagen("VerExamen", "true", Dato.Extension),
                                      CrearCeldaEliminar("EliminarExamen")];
                            $get("TbExamenes").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "LimpiarFilas"));
                        });
                    else {
                        Celdas = [CrearCelda("", "left"), CrearCelda("No hay Exámenes Diagnósticos y Documentos Externos en Ésta Atención", "center"), CrearCelda("", "center"), CrearCelda("", "center"), CrearCelda("", "center"), CrearCelda("", "center")];
                        $get("TbExamenes").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, ""));
                    }
                },
                error: function (Respuesta) {
                    Progreso(false);
                    Mensaje("Error", JSON.parse(Respuesta.responseText).Message);
                }
            });
        }


        function EliminarExamen(boton) {
            Datos = boton.parentNode.parentNode;
            if (confirm("¿Está seguro de eliminar este examen?")) {
                Progreso(true);
                $.ajax({
                    type: "POST",
                    data: "{ 'IdExamenDiagnostico': '" + Datos.children[0].innerHTML +
                        "'}",
                    url: "ExamenesDiagnosticos.aspx/HistoriaClinica_ExamenDiagnosticoElimina",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (Respuesta) {
                        Progreso(false);
                        if (Respuesta.d > 0)
                            $get("TbExamenes").getElementsByTagName('tbody')[0].removeChild(Datos);
                    },
                    error: function (Respuesta) { Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                });
            }
            return false;
        }


        //Documentos Externos FIN

        function Errores(Excepcion) { Progreso(false); Mensaje("Fallo", Excepcion.get_message()); return false; }
    </script>
</asp:Content>

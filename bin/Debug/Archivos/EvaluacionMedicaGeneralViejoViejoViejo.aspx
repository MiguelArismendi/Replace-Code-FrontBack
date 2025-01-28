<%@ Page Title="" Language="VB" MasterPageFile="~/Pagina.master" AutoEventWireup="false"
    CodeFile="EvaluacionMedicaGeneral.aspx.vb" Inherits="HistoriaClinica_EvaluacionMedicaGeneral" %>

<%@ Register Src="~/Componentes/Diagnosticos.ascx" TagPrefix="asp" TagName="Diagnosticos" %>
<asp:Content ID="Content4" ContentPlaceHolderID="S" runat="Server">
    <link href="../Estilos/HistoriaClinica.css" rel="stylesheet" type="text/css" />
    <!-- <link href="../Estilos/jquery-ui.css" rel="stylesheet" /> -->
    <!-- <script src="../Scripts/jquery-ui.js" type="text/javascript"></script> -->
    <script src="../Scripts/Placeholder.jquery.js" type="text/javascript"></script>
    <script src="../Scripts/ckeditor/ckeditor.js"></script>
    <script src="../Scripts/ckeditor/jqueryckeditor.js"></script>
    <script src="../Scripts/moment.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            if ((typeof (Sys) === 'undefined') == false) { Sys.Application.add_load(AsignarClick); AsignarClick(); }
        });
        function Nuevo() {
            $get("HdfIdHistoriaClinica").value = "";
            $get("HdfIdHistoriaClinicaTemp").value = "";
        }
        function Posologia() { $get('TxtPosologia').value = $get('TxtCantidadPosologia').value + " cada " + $get('TxtDosis').value + " horas durante " + $get('TxtDias').value + " días."; $get('TxtCantidadMed').value = 24 / $get('TxtDosis').value * $get('TxtCantidadPosologia').value * $get('TxtDias').value; }
        function Anular() {
            if (confirm("¿Esta seguro que desea anular la historia?"))
                PageMethods.HistoriaClinica_HistoriasClinicasAnula($get('HdfIdHistoriaClinica').value, UsuarioDelSistema(), HistoriaClinica_HistoriasClinicasAnulaOK, Errores)
            return false;
        }

        //Juan

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
                url: "EvaluacionMedicaGeneral.aspx/HistoriaClinica_DocumentosExternosSelecciona",
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

        function HistoriaClinica_HistoriasClinicasAnulaOK(Resultado) {
            if (Resultado != "0") {
                Mensaje("Informacion", "Anulada con éxito");
                $get("SpanEstado").innerText = " -ANULADA";
                $get("HdfEstado").value = "ANULADA";
                for (var i in $get('TcHco').getElementsByTagName('input')) {
                    $get('TcHco').getElementsByTagName('input')[i].disabled = true;
                }
                $get("TxtPadecimientoActual").disabled = true;
                $get("TxtMotivoConsulta").disabled = true;
                Sys.UI.DomElement.addCssClass($get("TxtPadecimientoActual"), 'readonly');
                Sys.UI.DomElement.addCssClass($get("TxtMotivoConsulta"), 'readonly');
            }
        }
        function ImprimeOrdenMedicamento() {
            if ($get("HdfIdHistoriaClinica").value == "") {
                Mensaje("Fallo", "Para imprimir debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo"); return false;
            }
            else {
                if ($get("TbMedicamentos").childNodes[1].rows.length > 1) {
                    var Reporte = '../HistoriaClinica/OrdenMedicamento.ashx?Id=' + $get("HdfIdHistoriaClinica").value + '&V=' + $get('CbNumeroOrdenMedicamento').value + '&rd=' + Math.random(); open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
                }
                else { Mensaje("Fallo", "Aun no se han agregado medicamentos"); return false; }
            }
        }
        function ImprimeOrdenServicio() {
            if ($get("HdfIdHistoriaClinica").value == "") {
                Mensaje("Fallo", "Para imprimir debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo"); return false;
            }
            else {
                if ($get("TbServicios").childNodes[1].rows.length > 1) {
                    var Reporte = '../HistoriaClinica/OrdenesServicios.ashx?Id=' + $get("HdfIdHistoriaClinica").value + '&V=' + $get('CbNumeroOrdenServicio').value + '&rd=' + Math.random(); open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
                }
                else { Mensaje("Fallo", "Aun no se han agregado Servicios"); return false; }
            }
        }

        function ImprimirEvolucion() {
            if ($get("HdfIdHistoriaClinica").value == "") {
                Mensaje("Fallo", "Para imprimir debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo"); return false;
            }

            var IdEvoluciones = '';
            $.each($(".TrEvolucionSeleccionado"), function (index, Control) {
                if (Control.cells[4].children[0].checked) IdEvoluciones += Control.cells[0].innerHTML + "|";
            });

            if (IdEvoluciones != '') {
                IdEvoluciones = IdEvoluciones.substring(0, IdEvoluciones.length - 1);
                var Reporte = '../HistoriaClinica/Evoluciones.ashx?Id=' + $get("HdfIdHistoriaClinica").value + "&Tipo=HistoriasClinicasEvolucionesReporteSelecciona&IdEvoluciones=" + IdEvoluciones; open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;

            }
            else {
                Mensaje("Error", "Debe seleccionar una evolucion como minimo para la impresión");
            }

            return false;

            //var Reporte = '../HistoriaClinica/Evoluciones.ashx?Id=' + $get("HdfIdHistoriaClinica").value + "&Tipo=HistoriasClinicasEvolucionesHeridasGenerarReporteSelecciona"; open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
        }


        function ImprimeOrdenRemision() {
            if ($get("HdfIdHistoriaClinica").value == "") {
                Mensaje("Fallo", "Para imprimir debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo"); return false;
            }
            else {
                if ($get("TbOrdenRemisiones").childNodes[1].rows.length > 1) {
                    var Reporte = '../HistoriaClinica/OrdenesRemisiones.ashx?Id=' + $get("HdfIdHistoriaClinica").value + '&V=' + $get('CbNumeroOrdenRemision').value + '&rd=' + Math.random(); open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
                }
                else { Mensaje("Fallo", "Aun no se han agregado Remisiones"); return false; }
            }
        }
        function desbloquear() {
            for (var i in $get('TcHco').getElementsByTagName('input')) {
                $get('TcHco').getElementsByTagName('input')[i].disabled = false;
            }
            for (var i in $get('TcHco').getElementsByTagName('textarea')) {
                $get('TcHco').getElementsByTagName('textarea')[i].disabled = false;
            }
            for (var i in $get('TcHco').getElementsByTagName('select')) {
                $get('TcHco').getElementsByTagName('select')[i].disabled = false;
            }
            for (var i in $get('TcHco').getElementsByTagName('radio')) {
                $get('TcHco').getElementsByTagName('select')[i].disabled = false;
            }
            $get("TxtFecha").disabled = false;
            Sys.UI.DomElement.removeCssClass($get("TxtFecha"), 'readonly');
            $get("TxtMunicipio").disabled = false;
            Sys.UI.DomElement.removeCssClass($get("TxtMunicipio"), 'readonly');

            if ($('.radio').length > 0)
                $('.radio').buttonset("option", "disabled", false);

            $(".ui-helper-hidden-accessible").attr('disabled', false);

            $.each($("#p8 input,#p8 select,#p8 textarea"), function (index, input) {
                input.classList.remove("readonly");
                input.disabled = false;
            });
        }
        function bloquear() {
            for (var i in $get('TcHco').getElementsByTagName('input')) {
                $get('TcHco').getElementsByTagName('input')[i].disabled = true;
            }
            for (var i in $get('TcHco').getElementsByTagName('textarea')) {
                $get('TcHco').getElementsByTagName('textarea')[i].disabled = true;
            }
            for (var i in $get('TcHco').getElementsByTagName('select')) {
                $get('TcHco').getElementsByTagName('select')[i].disabled = true;
            }
            for (var i in $(".Concepto")) {
                $(".Concepto")[i].disabled = true;
            }
            //Juan Bloquear
            for (var i in $(".RequisitosSalud")) {
                $(".RequisitosSalud")[i].disabled = true;
            }

            $get("TxtFecha").disabled = true;
            Sys.UI.DomElement.addCssClass($get("TxtFecha"), 'readonly');
            $get("TxtMunicipio").disabled = true;
            Sys.UI.DomElement.addCssClass($get("TxtMunicipio"), 'readonly');

            if ($('.radio').length > 0)
                $('.radio').buttonset("option", "disabled", true);

            $(".ui-helper-hidden-accessible").attr('disabled', true);


            for (var i in $get('TpOmed').getElementsByTagName('input')) {
                $get('TpOmed').getElementsByTagName('input')[i].disabled = false;
            }
            for (var i in $get('TpOmed').getElementsByTagName('textarea')) {
                $get('TpOmed').getElementsByTagName('textarea')[i].disabled = false;
            }
            for (var i in $get('TpOmed').getElementsByTagName('select')) {
                $get('TpOmed').getElementsByTagName('select')[i].disabled = false;
            }

            $.each($("#p8 input,#p8 select,#p8 textarea"), function (index, input) {
                input.classList.remove("readonly");
                input.disabled = false;
            });

            //ControlesNoBloqueables();
        }

        var Retornar = true;
        function AsignarClick() {
            ReporsitorioFunciones.DocumentosPermitidos();
            ReporsitorioFunciones.AyudaCargueArchivo('ArchivoPermitido');
            $('textarea#TxtDescripcionCertificacion').ckeditor();
            $("#AsyncFuFoto div:eq(1)").addClass("Ocultar");
            MostrarCantPaci();
            $get("SpanEstado").innerText = " -" + $get("HdfEstado").value;
            $get("SpanIdHistoriaClinica").innerText = $get("HdfIdHistoriaClinica").value;
            $('#C_GvHistoriaClinicaBuscar tr').css("cursor", "pointer");
            $('#C_GvHistoriaClinicaBuscar tr').click(function (Fila) {
                __doPostBack(Fila.currentTarget.getElementsByTagName("input")[0].name, "");
            });
            $('#B_BH_BtnGuardar').unbind('click');
            $('#B_BH_TdAnular').unbind('click');
            $('#B_BH_TdAprobar').unbind('click');
            $('#B_BH_TdBuscar').click(function () {
                $find("MpePnBuscar").show();
                return false;
            });
            $('#B_BH_TdGuardar').click(function () { GuardaHistoriaClinica(); return false; });
            $('#B_BH_TdNuevo').click(function () { Nuevo(); });
            //$('#B_BH_BtnImprimir').click(function () { if ($get("HdfIdHistoriaClinica").value == "") { Mensaje("Fallo", "Para imprimir debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo"); return false; } var Reporte = '../HistoriaClinica/HistoriasClinicas/' + $get("HdfIdHistoriaClinica").value + '.pdf?rd=' + Math.random(); open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false; });
            $('#B_BH_TdImprimir').click(function () {
                if ($get("HdfIdHistoriaClinica").value == "") { Mensaje("Fallo", "Para imprimir debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo"); return false; }
                Progreso(true);
                var Reporte = '../HistoriaClinica/EvaluacionMedicaGeneral.ashx?Id=' + $get("HdfIdHistoriaClinica").value; open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes');
                Progreso(false);
                //$.ajax({
                // type: "POST",
                // data: "{ 'IdHistoriaClinica': '" + $get("HdfIdHistoriaClinica").value +
                //     "','Reporte': '" + "EvaluacionMedicaGeneral" +
                //        "','Carpeta': '" + "HistoriasClinicas" +
                //         "','Pa': '" + "HistoriaClinica.HistoriasClinicasGeneralGenerarReportesSelecciona" +
                //       "'}",
                // url: "EvaluacionMedicaGeneral.aspx/GenerarReportes",
                // contentType: "application/json; charset=utf-8",
                // dataType: "json",
                // success: function (Respuesta) {
                //  Progreso(false);
                //  if (Respuesta.d == "1") {
                //   var Reporte = '../HistoriaClinica/HistoriasClinicas/' + $get("HdfIdHistoriaClinica").value + ".pdf?rd=" + Math.random();
                //   open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
                //  }
                // },
                // error: function (Respuesta) { Progreso(false); Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                //});
                return false;
            });
            $('#B_BH_TdAnular').click(function () { if ($get("HdfIdHistoriaClinica").value == "") { Mensaje("Fallo", "Para anular debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo"); return false; } Anular(); return false; });
            $('#B_BH_TdAprobar').click(function () { if ($get("HdfIdHistoriaClinica").value == "") { Mensaje("Fallo", "Para aprobar debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo"); return false; } VerificaryAprobar(); return false; });
            $(".radio").buttonset();
            $(':input[placeholder]').placeholder();
            Retornar = true;
            window.onbeforeunload = function PreguntarAntesSalir() {
                if (Retornar)
                    return 'Si sale y aun no ha guardado, la información se perderá.'
            }
            if ($get("TxtNumeroIdentificacion").value != "") {
                $.ajax({
                    url: "../Fotos/" + $get("TxtNumeroIdentificacion").value + ".jpg",
                    success: function (data) {
                        $get("ImgFoto").src = "../Fotos/" + $get("TxtNumeroIdentificacion").value + ".jpg?" + 'A=' + Math.random();
                    },
                    error: function (data) {
                        $get("ImgFoto").src = "../Imagenes/silueta.png"
                    },
                });
            }
            Diagnosticos.DiagnosticosSelecciona();
/*
if ($get('HdfHistoricoDiagnostico').value != "") {

                Diagnosticos = $get('HdfHistoricoDiagnostico').value.split("~");
                for (var i in Diagnosticos) {
                    DatoDiagnosticos = Diagnosticos[i].split("|");
                    Celdas = [CrearCelda(DatoDiagnosticos[0], "left", "Invisible"), CrearCelda(DatoDiagnosticos[0], "left"), CrearCelda(DatoDiagnosticos[1], "left"), CrearCelda(DatoDiagnosticos[2], "left"), CrearCelda(DatoDiagnosticos[3], "left"), CrearCelda(DatoDiagnosticos[4], "left"), CrearCelda(DatoDiagnosticos[5], "left")];
                    $get("TbHistoricoDiagnostico").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas));
                }
            }
*/
            /*
if ($get("TbHistoricoDiagnostico").getElementsByTagName('tbody')[0].getElementsByTagName('tr').length == 0) {
                Celdas = [CrearCelda("Sin Históricos para esta persona", "left", "", 6)];
                $get("TbHistoricoDiagnostico").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas));
            }
*/
            /*
$get('HdfHistoricoDiagnostico').value = "";
*/

            /*
if ($get('HdfDiagnosticos').value != "") {
                $('#TbDiagnosticos').children('tr').remove();
                Diagnosticos = $get('HdfDiagnosticos').value.split("~");
                for (var i in Diagnosticos) {
                    DatoDiagnosticos = Diagnosticos[i].split("|");
                    Celdas = [CrearCelda(DatoDiagnosticos[0], "left", "Invisible"), CrearCelda(DatoDiagnosticos[0], "left"), CrearCelda(DatoDiagnosticos[1], "left"), CrearCelda(DatoDiagnosticos[2], "left"), CrearCelda(DatoDiagnosticos[3], "left"), CrearCeldaEliminar("EliminarDiagnostico")];
                    $get("TbDiagnosticos").getElementsByTagName('tbody')[0].insertBefore(CrearFila(Celdas), $get("TrDiagnosticos"));
                }
            }
*/


            if ($get('HdfEvolucionMedica').value != "") {
                Evoluciones = $get('HdfEvolucionMedica').value.split("~");
                for (var i in Evoluciones) {
                    DatoEvoluciones = Evoluciones[i].split("|");
                    Celdas = [CrearCelda(DatoEvoluciones[0], "left", "Invisible"),
                              CrearCelda(DatoEvoluciones[4], "center"),
                              CrearCelda(DatoEvoluciones[2], "left"),
                              CrearCelda(DatoEvoluciones[3], "left"),
                              CrearCelda('<input type="checkbox" />', "center")];
                    $get("TbEvoluciones").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "TrEvolucionSeleccionado"));
                }
            }
            $get('HdfEvolucionMedica').value = "";

            if ($get('HdfTbMedicamentos').value != "") {
                $get('CbNumeroOrdenMedicamento').options.length = 0;
                Medicamentos = $get('HdfTbMedicamentos').value.split("~");
                for (var i in Medicamentos) {
                    DatoMedicamentos = Medicamentos[i].split("|");
                    Celdas = [CrearCelda(DatoMedicamentos[0], "left", "Invisible"), CrearCelda(DatoMedicamentos[1], "left"), CrearCelda(DatoMedicamentos[2], "center"), CrearCelda(DatoMedicamentos[3], "left"), CrearCeldaEliminar("EliminarMedicamento")];
                    $get("TbMedicamentos").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "Eliminar"));
                }
                for (i = 1; i <= ParsearNumero(Medicamentos[0].split("|")[4]) ; i++) {
                    $('#CbNumeroOrdenMedicamento').append("<option value=" + i + ">" + i + "</option>");
                }
                $('#CbNumeroOrdenMedicamento').val(Medicamentos[0].split("|")[4])
            }

            if ($get('HdfTbServicio').value != "") {
                $get('CbNumeroOrdenServicio').options.length = 0;
                Servicios = $get('HdfTbServicio').value.split("~");
                for (var i in Servicios) {
                    DatoServicios = Servicios[i].split("|");
                    Celdas = [CrearCelda(DatoServicios[0], "left", "Invisible"), CrearCelda(DatoServicios[1], "left"), CrearCelda(DatoServicios[2], "left"), CrearCelda(DatoServicios[3], "center"), CrearCeldaEliminar("EliminarOrdenServicio")];
                    $get("TbServicios").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "Eliminar"));
                }
                for (i = 1; i <= ParsearNumero(Servicios[0].split("|")[4]) ; i++) {
                    $('#CbNumeroOrdenServicio').append("<option value=" + i + ">" + i + "</option>");
                }
                $('#CbNumeroOrdenServicio').val(Servicios[0].split("|")[4])
            }

            if ($get('HdfTbOrdenRemision').value != "") {
                $get('CbNumeroOrdenRemision').options.length = 0;
                Remisiones = $get('HdfTbOrdenRemision').value.split("~");
                for (var i in Remisiones) {
                    DatoRemisiones = Remisiones[i].split("|");
                    Celdas = [CrearCelda(DatoRemisiones[0], "left", "Invisible"), CrearCelda(DatoRemisiones[1], "left"), CrearCelda(DatoRemisiones[2], "left"), CrearCeldaEliminar("EliminarOrdenRemision")];
                    $get("TbOrdenRemisiones").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "Eliminar"));
                }
                for (i = 1; i <= ParsearNumero(Remisiones[0].split("|")[3]) ; i++) {
                    $('#CbNumeroOrdenRemision').append("<option value=" + i + ">" + i + "</option>");
                }
                $('#CbNumeroOrdenRemision').val(Remisiones[0].split("|")[3])
            }
            $(".radio").buttonset();
            CalculaIMC();
            ClasificarHTA();
            InerpretacionPerimeroAbdominal();

            if ($get("HdfEstado").value != "ABIERTA")
                bloquear();
            else
                desbloquear();


            LlenarTablaExamenDiagnostico();
            CargarOrdenIncapacidad(true);
            CargarOrdenCertificacion(true);

            $('th input:checkbox').change(function () {
                if (this.checked) $('td input:checkbox').prop('checked', true);
                else $('td input:checkbox').prop('checked', false);
            });
        }

        function CargarOrdenIncapacidad(Inicio) {
            Progreso(true);
            if (Inicio)
                PageMethods.HistoriaClinica_OrdenesIncapacidadesSelecciona($get('HdfIdHistoriaClinica').value, "", HistoriaClinica_OrdenesIncapacidadesSeleccionaOK, Errores)
            else
                PageMethods.HistoriaClinica_OrdenesIncapacidadesSelecciona($get('HdfIdHistoriaClinica').value, $get("CbNumeroOrdenIncapacidad").value, HistoriaClinica_OrdenesIncapacidadesSeleccionaOK, Errores)
        }

        function GuardarOrdenIncapacidad() {
            $(".ErrorValidacion").removeClass("ErrorValidacion");
            if ($get("HdfIdHistoriaClinica").value != "") {
                Validar($get("TxtMotivoIncapacidad"), false, 'ErrorValidacion');
                Validar($get("TxtDiasDeIncapacidad"), false, 'ErrorValidacion');
                if (!$(".ErrorValidacion").length > 0) {
                    Progreso(true);
                    PageMethods.HistoriaClinica_OrdenesIncapacidadesInserta($get("HdfIdHistoriaClinica").value, $get("TxtMotivoIncapacidad").value
                        , $get("TxtDiasDeIncapacidad").value, $get("CbTipoIncapacidad").value, $get("CbNumeroOrdenIncapacidad").value
                        , $get("TxtFechaInicial").value, $get("TxtFechaFinal").value
                        , HistoriaClinica_OrdenesIncapacidadesInsertaOK, Errores);
                }
            }
        }

        function HistoriaClinica_OrdenesIncapacidadesInsertaOK(Resultado) {
            Progreso(false);
            Resultado = Resultado.split("|")
            if (Resultado[0] == "0")
                Mensaje("Advertencia", "No se puede crear el registro, por favor revise y vuelva a intentarlo");
            else {
                Celdas = [CrearCelda(Resultado[1], "left", "Invisible"), CrearCelda($get("TxtMotivoIncapacidad").value, "left"), CrearCelda($get("TxtDiasDeIncapacidad").value, "center"), CrearCelda($get("CbTipoIncapacidad").value, "left"), CrearCeldaEliminar("EliminarOrdenIncapacidad")];
                $get("TbOrdenIncapacidad").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "Eliminar"));
                $get("TxtMotivoIncapacidad").value = "";
                $get("TxtDiasDeIncapacidad").value = "";
                $get("CbTipoIncapacidad").value = "";
                $get("TxtFechaInicial").value = "";
                $get("TxtFechaFinal").value = "";
            }
        }

        function HistoriaClinica_OrdenesIncapacidadesSeleccionaOK(R) {
            $("#TbOrdenIncapacidad tbody").children('tr:not(:first)').remove();
            var Filas = 0;
            $.each(JSON.parse(R).Datos, function (i, Fila) {
                Celdas = [CrearCelda(Fila.IdOrdenIncapacidad, "left", "Invisible"), CrearCelda(Fila.MotivoIncapacidad, "left"), CrearCelda(Fila.DiasIncapacidad, "center"), CrearCelda(Fila.Tipo, "left"), CrearCeldaEliminar("EliminarOrdenIncapacidad")];
                $get("TbOrdenIncapacidad").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "Eliminar"));
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
            if (confirm("¿Desea elminar este registro?")) {
                Progreso(true);
                FilaOrdenIncapacidad = Boton.parentNode.parentNode;
                PageMethods.HistoriaClinica_OrdenesIncapacidadesElimina(FilaOrdenIncapacidad.cells[0].innerHTML, HistoriaClinica_OrdenesIncapacidadesEliminaOK, Errores);
            }
            return false;
        }

        function HistoriaClinica_OrdenesIncapacidadesEliminaOK(Resultado) {
            Progreso(false);
            if (Resultado > 0)
                $get("TbOrdenIncapacidad").getElementsByTagName('tbody')[0].removeChild(FilaOrdenIncapacidad);
            FilaOrdenIncapacidad = "";
        }

        function ImprimeOrdenIncapacidades() {
            if ($get("HdfIdHistoriaClinica").value == "") {
                Mensaje("Fallo", "Para imprimir debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo");
                return false;
            }
            else {
                if ($get("TbOrdenIncapacidad").childNodes[1].rows.length > 1) {
                    var Reporte = '../HistoriaClinica/OrdenesIncapacidades.ashx?Id=' + $get("HdfIdHistoriaClinica").value + '&V=' + $get('CbNumeroOrdenIncapacidad').value; open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes');
                    return false;
                }
                else { Mensaje("Fallo", "Aun no se han agregado Incapacidades"); return false; }
            }
        }
        function AsignarContextKey(IdAce) {
            $find(IdAce.replace('Txt', 'AceTxt')).set_contextKey($get('HdfGenero').value + "|" + $get('HdfIdHistoriaClinica').value);
        }
        function AsignarContextKeyDiagnostico(IdAce) {
            $find(IdAce.replace('Txt', 'AceTxt')).set_contextKey($find(IdAce.replace('Txt', 'AceTxt'))._contextKey + "|" + $get('HdfGenero').value + "|" + $get('HdfIdHistoriaClinica').value);
        }



        function AsignarIdDiagnostico(source, eventArgs) {
            var a = eventArgs.get_value()
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



        function AsignarIdMedicamento(source, eventArgs) {
            var a = eventArgs.get_value()
            $get("HdfIdMedicamento").value = a;

        }



        function Aprobar() {
            if ($get("HdfIdHistoriaClinica").value != "")
                PageMethods.HistoriaClinica_HistoriasClinicasAprueba($get("HdfIdHistoriaClinica").value, HistoriaClinica_HistoriasClinicasApruebaOK, Errores)
        }

        function HistoriaClinica_HistoriasClinicasApruebaOK(Respuesta) {
            Respuesta = Respuesta.split("|");
            if (Respuesta[0] == "")
                $(".FSignosVitales").addClass('fielderror');
            else
                $(".FSignosVitales").removeClass('fielderror');

            if (Respuesta[2] == "")
                $(".FFisicos").addClass('fielderror');
            else
                $(".FFisicos").removeClass('fielderror');
            if (Respuesta[11] == "")
                $(".FParaclinicos").addClass('fielderror');
            else
                $(".FParaclinicos").removeClass('fielderror');
            if (Respuesta[12] == "")
                $(".FDiagnosticos").addClass('fielderror');
            else
                $(".FDiagnosticos").removeClass('fielderror');
            if (Respuesta[13] == "")
                $(".FRevisionesSistemas").addClass('fielderror');
            else
                $(".FRevisionesSistemas").removeClass('fielderror');

            if (Respuesta[15] == "")
                $(".FValidaItems").addClass('fielAdvertencia');
            else
                $(".FValidaItems").removeClass('fielAdvertencia');
            if (verificayaprueba == "SI")
                AprobarOK();
        }


        function AgregarDiagnostico() {
            if ($get("HdfIdHistoriaClinica").value != "") {
                if ($get("HdfIdDiagnostico").value == "")
                    Sys.UI.DomElement.addCssClass($get("TxtDiagnostico"), 'ErrorValidacion');
                else
                    Sys.UI.DomElement.removeCssClass($get("TxtDiagnostico"), 'ErrorValidacion');
                if (!$(".ErrorValidacion").length > 0)
                    PageMethods.HistoriaClinica_DiagnosticosInserta($get("HdfIdHistoriaClinica").value, $get("HdfIdDiagnostico").value, $get("CbOrigen").value, $get("CbTipo").value, HistoriaClinica_DiagnosticosInsertaOK, Errores);
            }
        }
        function HistoriaClinica_DiagnosticosInsertaOK(Resultado) {
            if (Resultado == "0")
                Mensaje("Advertencia", "No se puede crear el registro, por favor revise y vuelva a intentarlo");
            else {
                Celdas = [CrearCelda($get("HdfIdDiagnostico").value, "left", "Invisible"), CrearCelda($get("HdfIdDiagnostico").value, "left"), CrearCelda($get("TxtDiagnostico").value, "left"), CrearCelda($get("CbOrigen").value, "left"), CrearCelda($get("CbTipo").value, "left"), CrearCeldaEliminar("EliminarDiagnostico")];
                $get("TbDiagnosticos").getElementsByTagName('tbody')[0].insertBefore(CrearFila(Celdas), $get("TrDiagnosticos"));
                $.each($("#TrDiagnosticos input"), function (index, Control) {
                    Control.value = "";
                });
                $get("HdfIdDiagnostico").value = "";
            }
        }
        var FilaDiagnostico
        function EliminarDiagnostico(Boton) {
            if ($get("HdfEstado").value == "ABIERTA") {
                if (confirm("¿Desea eliminar este registro.?")) {
                    Progreso(true);
                    FilaDiagnostico = Boton.parentNode.parentNode;
                    PageMethods.HistoriaClinica_DiagnosticosElimina(FilaDiagnostico.cells[0].innerText, $get("HdfIdHistoriaClinica").value, HistoriaClinica_DiagnosticosEliminaOK, Errores);
                }
            }
            return false;
        }
        function HistoriaClinica_DiagnosticosEliminaOK(Resultado) {
            Progreso(false);
            if (Resultado > 0)
                $get("TbDiagnosticos").getElementsByTagName('tbody')[0].removeChild(FilaDiagnostico);
            FilaAccidenteTrabajo = "";
        }
        function MostrarCantPaci() {
            $get("CantidadPacientes").innerHTML = "Cargando pacientes pendientes por atender para el día: " + $("#TxtFechaAtencion").val() + ".";
            $.each($(".EliminarFilas"), function (i, fila) { $(fila).remove(); });
            $("#TbTurnos").append('<tr class="EliminarFilas"><td colspan="10"><div style="width:100%; text-align:center; font-size:36px;font-weight:bold;text-transform:none;">Cargando Datos. . .<br><img src="../Imagenes/Cargando.gif"></div></td></tr>');
            PageMethods.ConsultaPaci(UsuarioDelSistema(), finllamada);
            if (timerID != undefined)
                clearTimeout(timerID);
            timerID = setTimeout("MostrarCantPaci()", 180000);
        }

        function finllamada(resultado) {
            $get("CantidadPacientes").innerHTML = "Para el día: " + $("#TxtFechaAtencion").val() + ", hay " + resultado + " pacientes pendientes por atender.";
            $.ajax({
                type: "POST",
                data: "{ 'LoginProfesional': '" + UsuarioDelSistema() +

                    "'}",
                url: "EvaluacionMedicaGeneral.aspx/Prestador_RemisionesAtencionesGenerales",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (Respuesta) {
                    $.each($(".EliminarFilas"), function (i, fila) {
                        $(fila).remove();
                    });

                    $.each(JSON.parse(Respuesta.d).Turnos, function (i, Turno) {
                        Celdas = [CrearCeldaSeleccionar("TipoAtencion"),
                                 CrearCelda(Turno.IdOrdenServicio, "center", "Invisible"),
                                 CrearCelda(Turno.IdHistoriaClinica, "center", "Invisible"),
                                 CrearCelda(Turno.Estado, "Left"),
                                 CrearCelda(Turno.NombreProducto, "Left"),
                                 CrearCelda(Turno.FechaCreacion, "center"),
                                 CrearCelda(Turno.NumeroIdentificacion, "Left"),
                                 CrearCelda(Turno.Nombre, "Left"), CrearCelda(Turno.NombreEmpresa, "Left")];
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
            datos = datos.parentNode.parentNode.cells;
            if (datos[3].innerHTML == "PENDIENTE") {
                DatoTurno = datos;
                $find("MpePnEvolucion").show();
            } else {
                $get("HdfIdHistoriaClinicaTemp").value = datos[2].innerHTML;
                Retornar = false
                __doPostBack('', null);
            }
            return false;
        }

        function AtencionControl() {
            $find("MpePnEvolucion").hide();
            datos = DatoTurno
            $get("HdfIdOrdenServicioControl").value = datos[1].innerHTML;
            Progreso(true);
            $.ajax({
                type: "POST",
                data: "{ 'NumeroIdentificacion': '" + datos[6].innerHTML +
                  "'}",
                url: NombreFormulario() + "/HistoriaClinica_BuscarHistoriasClinicasAtencionesControl",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (Respuesta) {
                    Respuesta = JSON.parse(Respuesta.d);
                    if (Respuesta.Datos.length > 0) {
                        $get("HdfIdHistoriaClinicaTemp").value = Respuesta.Datos[0].IdHistoriaClinica
                        Retornar = false
                        __doPostBack('', null);
                    }
                    else {
                        AtencionPrimeraVez();
                        //swal({ title: "Queremos decirte que", text: "no existe una atención anterior para este paciente, por favor ingresa por atención por primera vez.", type: "info", confirmButtonColor: "#0098DA", confirmButtonText: "Entendido", html: true }); return false;
                        // Progreso(false);
                    }
                },
                error: function (Respuesta) { Progreso(false); Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
            });
        }

        function AtencionPrimeraVez() {
            $find("MpePnEvolucion").hide();
            AsignarTurno(DatoTurno);
        }



        function AsignarTurno(datos) {
            Progreso(true)
            desbloquear();
            $find("CpPnGvTurnos")._doClose();
            //datos = datos.parentNode.parentNode.cells;
            $get("TxtNumeroIdentificacion").value = datos[6].innerText;
            $get("HdfIdHistoriaClinica").value = datos[2].innerText;
            $get("HdfIdOrdenServicio").value = datos[1].innerText;
            $get("HdfIdOrdenServicioControl").value = datos[1].innerText;

            //if (datos[3].innerText == "PENDIENTE") {
            var f = new Date();
            $get("TxtFecha").value = f.getDate() + "/" + (f.getMonth() + 1) + "/" + f.getFullYear();
            PageMethods.HistoriaClinica_HistoriasClinicasIsertaActualiza($get("TxtFecha").value, $get("HdfMunicipio").value, datos[6].innerText, datos[1].innerText, 0, 0, 0, 0, 0, 0, 0, 0, 0, "", "", UsuarioDelSistema(), datos[2].innerText, "", HistoriaClinica_HistoriasClinicasIsertaActualizaOKPB, Errores);
            return false;
            //}
            //else {
            // $get("HdfIdHistoriaClinicaTemp").value = $get("HdfIdHistoriaClinica").value
            // Retornar = false
            // __doPostBack('', null);
            //}
        }

        function HistoriaClinica_HistoriasClinicasIsertaActualizaOKPB(Resultado) {
            Resultado = Resultado.split("|");
            if (Resultado[0] == "0")
                Mensaje("Advertencia", "No se puede crear la Historia Clínica, por favor revise y vuelva a intentarlo");
            else {
                $get("HdfIdHistoriaClinicaTemp").value = Resultado[1];
                $get("HdfEstado").value = "ABIERTA";
                Retornar = false
                __doPostBack('', null);
            }
        }

        //insetar
        function GuardaHistoriaClinica() {
            $(".ErrorValidacion").removeClass("ErrorValidacion");
            if ($get("HdfIdHistoriaClinica").value != "") {
                if ($get("HdfEstado").value == "ABIERTA") {
                    if ($get("HdfMunicipio").value == "")
                        Sys.UI.DomElement.addCssClass($get("TxtMunicipio"), 'ErrorValidacion');
                    else
                        Sys.UI.DomElement.removeCssClass($get("TxtMunicipio"), 'ErrorValidacion');
                    Validar($get("TxtFecha"));
                    //   Validar($get("TxtSistolica"));  
                    //  Validar($get("TxtDiastolica"));
                    //  Validar($get("TxtFCardiaca"));
                    //  Validar($get("TxtFRespiratoria"));
                    //   Validar($get("TxtPeso"));
                    //  Validar($get("TxtTalla"));
                    //  Validar($get("CbLateralidadDominante"));
                    //  Validar($get("TxtPerimeroAbdominal"));

                    if ($(".ErrorValidacion").length > 0) {
                        Mensaje("Advertencia", "Faltan datos por llenar");
                    }
                    else {

                        $get("HdfRevisionesSistemas").value = "";
                        for (var i = 0; i < $get("RevisionSistema").rows.length; i++) {
                            $get("HdfRevisionesSistemas").value = $get("HdfRevisionesSistemas").value + $get("RevisionSistema").rows[i].cells[0].innerText + "|" + $get("RevisionSistema").rows[i].cells[1].getElementsByTagName('input')[0].value + "&";
                        }
                        $get("HdfExamenFisico").value = "";
                        $.each($(".ExamenFisico"), function (index, Control) {
                            $get("HdfExamenFisico").value = $get("HdfExamenFisico").value + Control.cells[0].innerText + "|" + Control.cells[1].getElementsByTagName('input')[0].value + "|" + Control.cells[0].getElementsByTagName('input')[0].value + "&";
                        });
                        $get("HdfParaclinicosSolicitados").value = "";
                        var Valoracion = "";
                        $.each($(".Trparaclinico"), function (index, Control) {
                            if (Control.cells[1].getElementsByClassName('ui-state-active')[0] != undefined)
                                Valoracion = Control.cells[1].getElementsByClassName('ui-state-active')[0].getElementsByTagName('span')[0].innerHTML;
                            $get("HdfParaclinicosSolicitados").value = $get("HdfParaclinicosSolicitados").value + Control.cells[0].getElementsByTagName('input')[0].value + "|" + Valoracion + "|" + Control.cells[2].getElementsByTagName('input')[0].value + "&";
                        });
                        $get("HdfAntecedentes").value = "";
                        $.each($(".Antecedentes"), function (index, Control) {
                            $get("HdfAntecedentes").value = $get("HdfAntecedentes").value + Control.id + "|" + Control.cells[0].innerText + "|" + Control.cells[1].getElementsByTagName('input')[0].value + "&";
                        });
                        var TipoConsulta = "";
                        if ($get("AL").checked)
                            TipoConsulta = "AL";
                        else
                            TipoConsulta = "EG";


                        $get("Hdfhabitos").value = "";
                        $.each($(".HabitoI"), function (index, Control) {
                            if (Control.cells[1].getElementsByTagName('input')[0].checked == true)
                                refiere = 1;
                            else
                                refiere = 0;
                            HabitoBuscado = Control.parentNode.parentNode.parentNode;
                            if ((HabitoBuscado.innerHTML).indexOf('Actividad Física') != -1) {
                                $get("Hdfhabitos").value = $get("Hdfhabitos").value + Control.cells[0].innerHTML + "|" + refiere + "|" + Control.cells[3].getElementsByTagName('input')[0].value + "|" + Control.cells[4].getElementsByTagName('select')[0].value + "|" + Control.cells[2].getElementsByTagName('input')[0].value + "&";
                            } else {
                                $get("Hdfhabitos").value = $get("Hdfhabitos").value + Control.cells[0].innerHTML + "|" + refiere + "|" + Control.cells[2].getElementsByTagName('input')[0].value + "|" + Control.cells[3].getElementsByTagName('select')[0].value + "|" + Control.cells[4].getElementsByTagName('input')[0].value + "&";
                            }
                        });


                        Progreso(true)


                        PageMethods.HistoriaClinica_HistoriasClinicasIsertaActualizaCompleto($get("TxtFecha").value, $get("HdfMunicipio").value, $get("TxtNumeroIdentificacion").value
                        , $get("HdfIdOrdenServicio").value, $get("TxtObservacionesParaclinicos").value, UsuarioDelSistema(), $get("HdfIdHistoriaClinica").value, "", $get("HdfRevisionesSistemas").value
                        , $get("HdfExamenFisico").value, $get("HdfParaclinicosSolicitados").value, $get("TxtSistolica").value, $get("TxtDiastolica").value, $get("TxtFCardiaca").value, $get("TxtFRespiratoria").value
                        , $get("TxtTemperatura").value, $get("TxtPeso").value, $get("TxtTalla").value, $get("CbLateralidadDominante").value, $get("TxtPerimeroAbdominal").value, $get("HdfAntecedentes").value
                        , $get("TxtPadecimientoActual").value, $get("TxtMotivoConsulta").value, TipoConsulta, $get("TxtPulsioximetria").value, $get("Hdfhabitos").value, $get("TxtPlanTerapeutico").value
                        , HistoriaClinica_HistoriasClinicasIsertaActualizaCompletoOK, Errores);
                    }

                }

                else {
                    Mensaje("Advertencia", "No se pueden guardar historias con estado " + $get("HdfEstado").value);
                }
            }
            else {
                Mensaje("Advertencia", "Debe abrir una historia clínica");
            }
        }
        var verificayaprueba;
        function VerificaryAprobar() {
            if (confirm("¿Esta seguro que desea aprobar la historia?")) {
                verificayaprueba = "SI";
                Aprobar();
            }
        }
        function AprobarOK() {
            if ($get("HdfEstado").value == "ABIERTA") {
                Progreso(true);
                if (!$(".fielderror").length > 0) {
                    PageMethods.HistoriaClinica_HistoriasClinicasApruebaOK($get("HdfIdHistoriaClinica").value, UsuarioDelSistema(), HistoriaClinica_HistoriasClinicasApruebaOKR, Errores)
                }
                else {
                    Mensaje("Advertencia", "No es posible aprobar la historia clínica con errores");
                    verificayaprueba = "NO";
                    Pogreso(false);
                }
            }
            else {
                Mensaje("Advertencia", "No es posible aprobar una historia clínica anulada O CERRADA"); return false;
            }
        }
        function HistoriaClinica_HistoriasClinicasApruebaOKR(Resultado) {
            if (Resultado > 0) {
                Mensaje("Informacion", "Aprobado con éxito");
                $get("SpanEstado").innerText = " -CERRADA";
                $get("HdfEstado").value = "CERRADA";
                verificayaprueba = "NO";
                $get("TxtPadecimientoActual").disabled = true;
                $get("TxtMotivoConsulta").disabled = true;
                Sys.UI.DomElement.addCssClass($get("TxtPadecimientoActual"), 'readonly');
                Sys.UI.DomElement.addCssClass($get("TxtMotivoConsulta"), 'readonly');
                $(".ui-helper-hidden-accessible").attr('disabled', true);

                for (var i in $get('TcHco').getElementsByTagName('input')) {
                    $get('TcHco').getElementsByTagName('input')[i].disabled = true;
                }
                for (var i in $get('TcHco').getElementsByTagName('select')) {
                    $get('TcHco').getElementsByTagName('select')[i].disabled = true;
                }


                $.each($("#p8 input,#p8 select,#p8 textarea"), function (index, input) {
                    input.classList.remove("readonly");
                    input.disabled = false;
                });


                $.ajax({
                    type: "POST",
                    data: "{ 'IdHistoriaClinica': '" + $get("HdfIdHistoriaClinica").value +
                        "','Reporte': '" + "EvaluacionMedicaGeneral" +
                        "','Carpeta': '" + "HistoriasClinicas" +
                        "','Pa': '" + "HistoriaClinica.HistoriasClinicasGeneralGenerarReportesSelecciona" +
                        "'}",
                    url: "EvaluacionMedicaGeneral.aspx/GenerarReportes",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (Respuesta) {
                        Progreso(false);
                        if (Respuesta.d == "1") {
                            var Reporte = '../HistoriaClinica/HistoriasClinicas/' + $get("HdfIdHistoriaClinica").value + ".pdf?rd=" + Math.random();
                            open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes'); return false;
                        }
                    },
                    error: function (Respuesta) { Progreso(false); Mensaje("Error", JSON.parse(Respuesta.responseText).Message); }
                });
                return false;
            }
            else {
                Progreso(false);
                Mensaje("Advertencia", "Error al aprobar"); return false;
                verificayaprueba = "NO";
            }
        }

        function HistoriaClinica_HistoriasClinicasIsertaActualizaCompletoOK(Resultado) {
            Resultado = Resultado.split("|");
            if (Resultado[0] == "0") {

                Mensaje("Advertencia", "No se puede crear la Historia Clínica, por favor revise y vuelva a intentarlo");
            }
            else {
                Aprobar();
                Mensaje("Informacion", "Guardado con éxito");
            }
            Progreso(false)
        }



        function BuscarVacio() {
            if (($get("BuscaNumeroIdentificacion").value == "" && $get("BuscaCliente").value == "" && $get("BuscaNoHistoriaClinica").value == "")) {
                Mensaje("Advertenca", "Debe escribir por lo menos un criterio de búsqueda, por favor revise y vuelva a intentarlo.");
                return false;
            }
            else {
                Progreso(true);
                __doPostBack("ctl00$C$BtnAceptaBuscar", "");
                return true;
            }
        }



        function ClasificarHTA() {
            if (($get("TxtSistolica").value != "") && ($get("TxtDiastolica").value != "")) {
                if (($get("TxtSistolica").value < 120) && ($get("TxtDiastolica").value < 80)) {
                    $get("TxtClasificacionHTA").value = "Optima";
                    $get("TxtClasificacionHTA").className = "";
                }
                else if (($get("TxtSistolica").value < 130) && ($get("TxtDiastolica").value < 85)) {
                    $get("TxtClasificacionHTA").value = "Normal";
                    $get("TxtClasificacionHTA").className = "";
                }
                else if (($get("TxtSistolica").value < 140) && ($get("TxtDiastolica").value < 90)) {
                    $get("TxtClasificacionHTA").value = "Normal Alta";
                    $get("TxtClasificacionHTA").className = "Estado1";
                }
                else if (($get("TxtSistolica").value < 160) && ($get("TxtDiastolica").value < 100)) {
                    $get("TxtClasificacionHTA").value = "Hipertensión Estado 1";
                    $get("TxtClasificacionHTA").className = "Estado2";
                }
                else if (($get("TxtSistolica").value < 180) && ($get("TxtDiastolica").value < 110)) {
                    $get("TxtClasificacionHTA").value = "Hipertensión Estado 2";
                    $get("TxtClasificacionHTA").className = "Estado3";
                }
                else if (($get("TxtSistolica").value < 210) && ($get("TxtDiastolica").value < 120)) {
                    $get("TxtClasificacionHTA").value = "Hipertensión Estado 3";
                    $get("TxtClasificacionHTA").className = "Estado4";
                }
                else
                    $get("TxtClasificacionHTA").value = "los valores no coinciden en la tabla de clasificación";
            }
        }
        function CalculaIMC() {
            if ($get("TxtPeso").value != "" && $get("TxtTalla").value != "") {
                if (ParsearNumero($get("TxtPeso").value) > 560) {
                    $get("TxtImc").value = "";
                    Mensaje("Advertencia", "La persona pesa mas de 560 kg favor reportar al los Guinness World Records");
                    Sys.UI.DomElement.addCssClass($get("TxtPeso"), 'ErrorValidacion');
                    return false
                }
                else
                    Sys.UI.DomElement.removeCssClass($get("TxtPeso"), 'ErrorValidacion');
                if (ParsearNumero($get("TxtTalla").value) > 272) {
                    $get("TxtImc").value = "";
                    Mensaje("Advertencia", "La persona mide mas de 2.72 mts favor reportar al los Guinness World Records");
                    Sys.UI.DomElement.addCssClass($get("TxtTalla"), 'ErrorValidacion');
                    return false
                }
                else { Sys.UI.DomElement.removeCssClass($get("TxtTalla"), 'ErrorValidacion'); }
                $get("TxtImc").value = ParsearNumero($get("TxtPeso").value) / ((ParsearNumero($get("TxtTalla").value) / 100) * (ParsearNumero($get("TxtTalla").value) / 100));
                $get("TxtImc").value = ParsearNumero($get("TxtImc").value).toFixed(2);
                if ($get("TxtImc").value >= 40) {
                    $get("TxtImc").value += " - Obesidad grado III";
                    $get("TxtImc").className = "Estado4";
                }
                else if ($get("TxtImc").value >= 35) {
                    $get("TxtImc").value += " - Obesidad grado II";
                    $get("TxtImc").className = "Estado3";
                }
                else if ($get("TxtImc").value > 30) {
                    $get("TxtImc").value += " - Obesidad grado I";
                    $get("TxtImc").className = "Estado2";
                }
                else if ($get("TxtImc").value > 25) {
                    $get("TxtImc").value += " - Sobrepeso";
                    $get("TxtImc").className = "Estado1";
                }
                else if ($get("TxtImc").value > 18.5) {
                    $get("TxtImc").value += " - Peso Normal";
                    $get("TxtImc").className = "";
                }
                else if ($get("TxtImc").value > 0) {
                    $get("TxtImc").value += " - Bajo Peso";
                    $get("TxtImc").className = "";
                }
            }
        }
        function InerpretacionPerimeroAbdominal() {
            if ($get("TxtPerimeroAbdominal").value != "" && $get("HdfGenero").value != "") {
                if ($get("HdfGenero").value == "MASCULINO") {
                    if (ParsearNumero($get("TxtPerimeroAbdominal").value) >= 90)
                        $get("TxtInerpretacionPerimeroAbdominal").value = "Alto Riesgo";
                    else
                        $get("TxtInerpretacionPerimeroAbdominal").value = "Bajo Riesgo";
                }
                if ($get("HdfGenero").value == "FEMENINO") {
                    if (ParsearNumero($get("TxtPerimeroAbdominal").value) >= 80)
                        $get("TxtInerpretacionPerimeroAbdominal").value = "Alto Riesgo";
                    else
                        $get("TxtInerpretacionPerimeroAbdominal").value = "Bajo Riesgo";
                }
            }
        }
        function esInteger(e) {
            var tecla = document.all ? tecla = e.keyCode : tecla = e.which;
            return ((tecla > 47 && tecla < 58) || tecla == 46);
        }


        function AsignarCodigoMunicipio(source, eventArgs) {
            $get("HdfMunicipio").value = eventArgs.get_value();
        }
        function AsignarIdServicio(source, eventArgs) {
            $get("HdfIdServicio").value = eventArgs.get_value();
        }
        function AsignarCodigoEspecialidad(source, eventArgs) {
            $get("HdfCodigoEspecialidad").value = eventArgs.get_value();
        }

        function GuardarOrdenRemision() {
            $(".ErrorValidacion").removeClass("ErrorValidacion");
            if ($get("HdfIdHistoriaClinica").value != "") {
                Validar($get("TxtEspecialidad"));
                if (!$(".ErrorValidacion").length > 0)
                    PageMethods.HistoriaClinica_OrdenesRemisionesInserta($get("HdfIdHistoriaClinica").value, $get("HdfCodigoEspecialidad").value, $get("TxtEspecialidad").value, $get("CbNumeroOrdenRemision").value, $get("TxtMotivoRemision").value, HistoriaClinica_OrdenesRemisionesInsertaOK, Errores)
            }
        }
        function HistoriaClinica_OrdenesRemisionesInsertaOK(Resultado) {
            Resultado = Resultado.split("|")
            if (Resultado[0] == "0")
                Mensaje("Advertencia", "No se puede crear el registro, por favor revise y vuelva a intentarlo");
            else {
                Celdas = [CrearCelda(Resultado[1], "left", "Invisible"), CrearCelda($get("TxtEspecialidad").value, "left"), CrearCelda($get("TxtMotivoRemision").value, "left"), CrearCeldaEliminar("EliminarOrdenRemision")];
                $get("TbOrdenRemisiones").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "Eliminar"));
                $.each($("#TbOrdenRemision input"), function (index, Control) {
                    Control.value = "";
                });

            }
        }
        var FilaRemision;
        function EliminarOrdenRemision(Boton) {
            if (confirm("¿Desea eliminar este registro?")) {
                Progreso(true);
                FilaRemision = Boton.parentNode.parentNode;
                PageMethods.HistoriaClinica_OrdenesRemisionesElimina(FilaRemision.cells[0].innerText, HistoriaClinica_OrdenesRemisionesEliminaOK, Errores)
            }
            return false;
        }
        function HistoriaClinica_OrdenesRemisionesEliminaOK(Resultado) {
            Progreso(false);
            if (Resultado > 0)
                $get("TbOrdenRemisiones").getElementsByTagName('tbody')[0].removeChild(FilaRemision);
            FilaRemision = "";
        }


        function GuardarServicio() {
            $(".ErrorValidacion").removeClass("ErrorValidacion");
            if ($get("HdfIdHistoriaClinica").value != "") {
                Validar($get("TxtServicio"));
                Validar($get("TxtCantidadServicio"));
                if (!$(".ErrorValidacion").length > 0)
                    PageMethods.HistoriaClinica_OrdenesServiciosInserta($get("HdfIdHistoriaClinica").value, $get("HdfIdServicio").value, $get("TxtCantidadServicio").value, $get("TxtServicio").value, $get("CbNumeroOrdenServicio").value, $get("TxtObservacionesServicios").value,
                        HistoriaClinica_OrdenesServiciosInsertaOK, Errores)
            }
        }
        function HistoriaClinica_OrdenesServiciosInsertaOK(Resultado) {
            Resultado = Resultado.split("|")
            if (Resultado[0] == "0")
                Mensaje("Advertencia", "No se puede crear el registro, por favor revise y vuelva a intentarlo");
            else {
                Celdas = [CrearCelda(Resultado[1], "left", "Invisible"), CrearCelda($get("TxtServicio").value, "left"), CrearCelda($get("TxtObservacionesServicios").value, "left"), CrearCelda($get("TxtCantidadServicio").value, "center"), CrearCeldaEliminar("EliminarOrdenServicio")];
                $get("TbServicios").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "Eliminar"));
                $.each($("#TbServicio input"), function (index, Control) {
                    Control.value = "";
                });

            }
        }
        var FilaServicio;
        function EliminarOrdenServicio(Boton) {
            if (confirm("¿Desea eliminar este registro?")) {
                Progreso(true);
                FilaServicio = Boton.parentNode.parentNode;
                PageMethods.HistoriaClinica_OrdenesServiciosElimina(FilaServicio.cells[0].innerText, HistoriaClinica_OrdenesServiciosEliminaOK, Errores)
            }
            return false;
        }

        function HistoriaClinica_OrdenesServiciosEliminaOK(Resultado) {
            Progreso(false);
            if (Resultado > 0)
                $get("TbServicios").getElementsByTagName('tbody')[0].removeChild(FilaServicio);
            FilaServicio = "";
        }
        function GuardarMedicamento() {
            $(".ErrorValidacion").removeClass("ErrorValidacion");
            if ($get("HdfIdHistoriaClinica").value != "") {
                Validar($get("TxtMedicamento"));
                Validar($get("TxtCantidadMed"));
                if (!$(".ErrorValidacion").length > 0)
                    PageMethods.HistoriaClinica_OrdenMedicamentoInserta($get("HdfIdHistoriaClinica").value, $get("HdfIdMedicamento").value, $get("TxtPosologia").value, $get("TxtCantidadMed").value, $get("TxtMedicamento").value, $get("CbNumeroOrdenMedicamento").value, HistoriaClinica_OrdenMedicamentoInsertaOK, Errores)
            }
        }

        function HistoriaClinica_OrdenMedicamentoInsertaOK(Resultado) {
            Resultado = Resultado.split("|")
            if (Resultado[0] == "0")
                Mensaje("Advertencia", "No se puede crear el registro, por favor revise y vuelva a intentarlo");
            else {
                Celdas = [CrearCelda(Resultado[1], "left", "Invisible"), CrearCelda($get("TxtMedicamento").value, "left"), CrearCelda($get("TxtCantidadMed").value, "center"), CrearCelda($get("TxtPosologia").value, "left"), CrearCeldaEliminar("EliminarMedicamento")];
                $get("TbMedicamentos").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "Eliminar"));
                $.each($("#TbMedicamento input"), function (index, Control) {
                    Control.value = "";
                });

            }
        }
        var FilaMedicamento;
        function EliminarMedicamento(Boton) {
            if (confirm("¿Desea eliminar este registro?")) {
                Progreso(true);
                FilaMedicamento = Boton.parentNode.parentNode;
                PageMethods.HistoriaClinica_OrdenMedicamentoElimina(FilaMedicamento.cells[0].innerText, HistoriaClinica_OrdenMedicamentoEliminaOK, Errores)
            }
            return false;
        }
        function HistoriaClinica_OrdenMedicamentoEliminaOK(Resultado) {
            Progreso(false);
            if (Resultado > 0)
                $get("TbMedicamentos").getElementsByTagName('tbody')[0].removeChild(FilaMedicamento);
            FilaMedicamento = "";
        }

        function FechaHoraEvolucion() {
            return $("#TxtFechaEvolucion").val() + " " + $("#CbHora").val() + ":" + $("#CbMinutos").val() + " " + $("#CbAmPm").val();
        }

        function GuardarEvolucion() {
            if ($get("HdfIdHistoriaClinica").value != "") {
                Validar($get("TxtEvolucion"));
                Validar($get("TxtFechaEvolucion"));
                Validar($get("CbHora"));
                Validar($get("CbMinutos"));
                Validar($get("CbAmPm"));
                if (!$(".ErrorValidacion").length > 0)
                    PageMethods.HistoriaClinica_HistoriasClinicasEvolucionesInserta($get('HdfIdHistoriaClinica').value, $get("TxtEvolucion").value
                     , UsuarioDelSistema(), FechaHoraEvolucion(), $get("HdfIdOrdenServicioControl").value
                     , HistoriaClinica_HistoriasClinicasEvolucionesInsertaOK, Errores);
            }
            else { Mensaje("Fallo", "Para Guardar debe tener abierta una historia, por favor revise y vuelva a intentarlo") }
            return false;
        }
        function HistoriaClinica_HistoriasClinicasEvolucionesInsertaOK(Resultado) {
            Resultado = Resultado.split("|")
            if (Resultado[0] == "0")
                Mensaje("Advertencia", "No se puede crear el registro, por favor revise y vuelva a intentarlo");
            else {
                $get("HdfIdOrdenServicioControl").value = "";
                Celdas = [CrearCelda(Resultado[1], "left", "Invisible"),
                          CrearCelda(FechaHoraEvolucion(), "center"),
                          CrearCelda(UsuarioDelSistema(), "left"),
                          CrearCelda($get("TxtEvolucion").value, "left"),
                          CrearCelda('<input type="checkbox" />', 'center')];
                $get("TbEvoluciones").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "TrEvolucionSeleccionado"));

                $.each($("#p8 input,#p8 select,#p8 textarea"), function (index, input) {
                    input.value = "";
                });


                for (var i in $get('TpOm').getElementsByTagName('input')) {
                    $get('TpOm').getElementsByTagName('input')[i].disabled = false;
                }
                for (var i in $get('TpSv').getElementsByTagName('input')) {
                    $get('TpSv').getElementsByTagName('input')[i].disabled = false;
                }
                for (var i in $get('TpOR').getElementsByTagName('input')) {
                    $get('TpOR').getElementsByTagName('input')[i].disabled = false;
                }

                for (var i in $get('TpOm').getElementsByTagName('select')) {
                    $get('TpOm').getElementsByTagName('select')[i].disabled = false;
                }
                for (var i in $get('TpSv').getElementsByTagName('select')) {
                    $get('TpSv').getElementsByTagName('select')[i].disabled = false;
                }
                for (var i in $get('TpOR').getElementsByTagName('select')) {
                    $get('TpOR').getElementsByTagName('select')[i].disabled = false;
                }

                MostrarCantPaci();
            }
        }
        var FilaEvolucion;
        function EliminarEvolucion(Boton) {
            FilaEvolucion = Boton.parentNode.parentNode;
            PageMethods.HistoriaClinica_HistoriasClinicasEvolucionesElimina(FilaEvolucion.cells[0].innerText, HistoriaClinica_HistoriasClinicasEvolucionesEliminaOK, Errores)
        }
        function HistoriaClinica_HistoriasClinicasEvolucionesEliminaOK(Resultado) {
            if (Resultado > 0)
                $get("TbEvoluciones").getElementsByTagName('tbody')[0].removeChild(FilaEvolucion);
            FilaEvolucion = "";
        }
        //function MarcarCheckSalud(boton) {
        //    boton.parentNode.parentNode.parentNode.cells(1).getElementsByTagName('input')[0].checked = true;
        //}

        //  function Errores(Excepcion) { Mensaje("Fallo", Excepcion.get_message()); return false; }

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

        function CargarMedicamentos() {
            PageMethods.HistoriaClinica_OrdenMedicamentoSelecciona($get('HdfIdHistoriaClinica').value, $get("CbNumeroOrdenMedicamento").value, HistoriaClinica_OrdenMedicamentoSeleccionaOK, Errores)
        }

        function HistoriaClinica_OrdenMedicamentoSeleccionaOK(Resultado) {
            $.each($("#TbMedicamentos tr"), function (i, fila) {
                if (fila.rowIndex != 0)
                    $(fila).remove()
            });
            if (Resultado != "") {

                Medicamentos = Resultado.split("~");
                for (var i in Medicamentos) {
                    DatoMedicamentos = Medicamentos[i].split("|");
                    Celdas = [CrearCelda(DatoMedicamentos[0], "left", "Invisible"), CrearCelda(DatoMedicamentos[1], "left"), CrearCelda(DatoMedicamentos[2], "center"), CrearCelda(DatoMedicamentos[3], "left"), CrearCeldaEliminar("EliminarMedicamento")];
                    $get("TbMedicamentos").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "Eliminar"));
                }
                $('#CbNumeroOrdenMedicamento').val(Medicamentos[0].split("|")[4])
            }
        }

        function CargarServicios() {
            PageMethods.HistoriaClinica_HcOrdenesServiciosSelecciona($get('HdfIdHistoriaClinica').value, $get("CbNumeroOrdenServicio").value, HistoriaClinica_HcOrdenesServiciosSeleccionaOK, Errores)
        }

        function HistoriaClinica_HcOrdenesServiciosSeleccionaOK(Resultado) {
            $.each($("#TbServicios tr"), function (i, fila) {
                if (fila.rowIndex != 0)
                    $(fila).remove()
            });
            if (Resultado != "") {

                Servicios = Resultado.split("~");
                for (var i in Servicios) {
                    DatoServicios = Servicios[i].split("|");
                    Celdas = [CrearCelda(DatoServicios[0], "left", "Invisible"), CrearCelda(DatoServicios[1], "left"), CrearCelda(DatoServicios[2], "left"), CrearCelda(DatoServicios[3], "center"), CrearCeldaEliminar("EliminarOrdenServicio")];
                    $get("TbServicios").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "Eliminar"));
                }
                $('#CbNumeroOrdenServicio').val(Servicios[0].split("|")[4])
            }
        }
        function CargarRemisiones() {
            PageMethods.HistoriaClinica_OrdenesRemisionesSelecciona($get('HdfIdHistoriaClinica').value, $get("CbNumeroOrdenRemision").value, HistoriaClinica_OrdenesRemisionesSeleccionaOK, Errores)
        }

        function HistoriaClinica_OrdenesRemisionesSeleccionaOK(Resultado) {
            $.each($("#TbOrdenRemisiones tr"), function (i, fila) {
                if (fila.rowIndex != 0)
                    $(fila).remove()
            });
            if (Resultado != "") {

                Remisiones = Resultado.split("~");
                for (var i in Remisiones) {
                    DatoRemisiones = Remisiones[i].split("|");
                    Celdas = [CrearCelda(DatoRemisiones[0], "left", "Invisible"), CrearCelda(DatoRemisiones[1], "left"), CrearCelda(DatoRemisiones[2], "left"), CrearCeldaEliminar("EliminarOrdenRemision")];
                    $get("TbOrdenRemisiones").getElementsByTagName('tbody')[0].appendChild(CrearFila(Celdas, "Eliminar"));
                }
                $('#CbNumeroOrdenRemision').val(Remisiones[0].split("|")[3])
            }
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
            $get("CantidadPacientes").innerHTML = "Cargando pacientes pendientes por atender para el día: " + $("#TxtFechaAtencion").val() + ".";
            $.each($(".EliminarFilas"), function (i, fila) { $(fila).remove(); });
            $("#TbTurnos").append('<tr class="EliminarFilas"><td colspan="10"><div style="width:100%; text-align:center; font-size:36px;font-weight:bold;text-transform:none; ">Cargando Datos. . .<br><img src="../Imagenes/Cargando.gif"></div></td></tr>');
            if ($("#TxtFechaAtencion").val() == "") {
                Mensaje("Advertencia", "Debe seleccionar una fecha, para mostrar los pacientes");
                return false;
            }
            if (!ValidarFormatoFecha($("#TxtFechaAtencion").val())) {
                Mensaje("Fallo", "Debe escribir una fecha valida en formato [dd/mm/aaaa] día, mes y año");
                return false;
            }
            PageMethods.AsignarFechaFiltro($get("TxtFechaAtencion").value, AsignarFechaFiltroOK);
            Fechavisible = false;
        }

        function ValidarFormatoFecha(Fecha) {
            var fechaf = Fecha.split("/");
            var d = fechaf[0];
            var m = fechaf[1];
            var y = fechaf[2];
            return m > 0 && m < 13 && y > 0 && y < 32768 && d > 0 && d <= (new Date(y, m, 0)).getDate();
        }
        function AsignarFechaFiltroOK() {
            MostrarCantPaci();
        }


        function NuevaOrdenCertificacion() {
            var NoOrdenCertificacion;
            NoOrdenCertificacion = ParsearNumero($('#CbNumeroOrdenCertificacion')[0][$('#CbNumeroOrdenCertificacion')[0].length - 1].value) + 1;
            $('#CbNumeroOrdenCertificacion').append("<option value=" + NoOrdenCertificacion + ">" + NoOrdenCertificacion + "</option>");
            $('#CbNumeroOrdenCertificacion').val(NoOrdenCertificacion);
            $('#TxtDescripcionCertificacion').val("");
            $('#HdfIdOrdenCertificacion').val("");
        }


        function CargarOrdenCertificacion(Inicio) {
            Progreso(true);
            if (Inicio)
                PageMethods.HistoriaClinica_OrdenesCertificacionSelecciona($get('HdfIdHistoriaClinica').value, "", HistoriaClinica_OrdenesCertificacionSeleccionaOK, Errores)
            else
                PageMethods.HistoriaClinica_OrdenesCertificacionSelecciona($get('HdfIdHistoriaClinica').value, $get("CbNumeroOrdenCertificacion").value, HistoriaClinica_OrdenesCertificacionSeleccionaOK, Errores)
        }

        function HistoriaClinica_OrdenesCertificacionSeleccionaOK(R) {
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


        function GuardarOrdenCertificacion() {
            if ($get("HdfEstado").value == "ABIERTA" || $get("HdfEstado").value == "CERRADA") {
                Progreso(true);
                $.ajax({
                    type: "POST",
                    data: "{ 'IdOrdenCertificacion': '" + $("#HdfIdOrdenCertificacion").val()
                        + "','IdHistoriaClinica': '" + $("#HdfIdHistoriaClinica").val()
                        + "','DescripcionCertificacion': '" + CKEDITOR.instances['TxtDescripcionCertificacion'].getData()
                        + "','Numero': '" + $("#CbNumeroOrdenCertificacion").val()
                        + "'}",
                    url: "EvaluacionMedicaGeneral.aspx/HistoriaClinica_OrdenesCertificacionInsertaActualiza",
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


        function ImprimeOrdenCertificacion() {
            if ($get("HdfIdHistoriaClinica").value == "") {
                Mensaje("Fallo", "Para imprimir debe tener abierta una historia clínica, por favor revise y vuelva a intentarlo");
                return false;
            }
            else {
                var Reporte = '../HistoriaClinica/OrdenesCertificacion.ashx?Id=' + $get("HdfIdHistoriaClinica").value + '&V=' + $get('CbNumeroOrdenCertificacion').value; open(Reporte, 'Tik', 'top=0,left=10,width=900,height=700,status=yes,resizable=no,scrollbars=yes');
                return false;
            }
        }

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
                        if (parseInt(Dias) == 1) {
                            $get("TxtFechaFinal").value = $get("TxtFechaInicial").value
                        } else {
                            $get("TxtFechaFinal").value = moment(FechaInicial).add(parseInt((Dias)) - 1, 'days').format("DD/MM/YYYY");
                        }
                    }
                }
            }
            return false;
        }

        function HistoricoOrdenes(TipoOrden) {
            if ($get("HdfIdHistoriaClinica").value != "") {
                Progreso(true);
                $.ajax({
                    type: "POST",
                    data: "{ 'IdHistoriaClinica': '" + $get("HdfIdHistoriaClinica").value +
                        "','TipoOrden': '" + TipoOrden +
                        "'}",
                    url: "EvaluacionMedicaGeneral.aspx/HistoriaClinica_OrdenesMedicasHistoricoSelecciona",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (Respuesta) {
                        var RespuestaEncabezado = JSON.parse(Respuesta.d).Table;
                        var RespuestaCuerpo = JSON.parse(Respuesta.d).Table1;
                        var RespuestaDatos = JSON.parse(Respuesta.d).Table2;
                        var Contenido = "";
                        document.getElementById("ContenidoPnHistorico").innerHTML = "";
                        if (RespuestaEncabezado.length > 0) {
                            // Ordenes Medicas
                            if (TipoOrden == "OM") {

                                $.each(RespuestaEncabezado, function (i, Encabezado) {
                                    Contenido += "<fieldset><legend> Atención N° " + Encabezado.IdHistoriaClinica + " del " + Encabezado.Fecha + " por el profesional " + Encabezado.LoginProfesional + "</legend>"
                                    $.each(RespuestaCuerpo, function (i, Fila) {
                                        if (Encabezado.IdHistoriaClinica == Fila.IdHistoriaClinica) {
                                            Contenido += "<fieldset style='border:none;text-align: left;'><legend>Orden de Medicamento Número " + Fila.Numero + "</legend>"
                                            Contenido += "<table class='Tabla'><thead><tr><th style='width: 500px'>Nombre del Medicamento</th><th style='width: 80px'>Cantidad</th><th style='width: 350px'>Posología</th></tr></thead><tbody>"
                                            $.each(RespuestaDatos, function (i, Datos) {
                                                if (Fila.Numero == Datos.Numero && Fila.IdHistoriaClinica == Datos.IdHistoriaClinica) {
                                                    Contenido += "<tr><td align='left'>" + Datos.NombreMedicamento + "</td><td align='center'>" + Datos.Cantidad + "</td><td align='left'>" + Datos.Posologia + "</td></tr>"
                                                }
                                            });
                                            Contenido += "</tbody></table></fieldset><br>"
                                        }
                                    });
                                    Contenido += "</fieldset><br><br>"
                                });

                                // Ordenes A Servicios
                            } else if (TipoOrden == "OS") {

                                $.each(RespuestaEncabezado, function (i, Encabezado) {
                                    Contenido += "<fieldset><legend> Atención N° " + Encabezado.IdHistoriaClinica + " del " + Encabezado.Fecha + " por el profesional " + Encabezado.LoginProfesional + "</legend>"
                                    $.each(RespuestaCuerpo, function (i, Fila) {
                                        if (Encabezado.IdHistoriaClinica == Fila.IdHistoriaClinica) {
                                            Contenido += "<fieldset style='border:none;text-align: left;'><legend>Orden a Servicio Número " + Fila.Numero + "</legend>"
                                            Contenido += "<table class='Tabla'><thead><tr><th style='width: 445px'>Nombre del Servicio</th><th style='width: 425px'>Observaciones</th><th style='width: 80px'>Cantidad</th></tr></thead><tbody>"
                                            $.each(RespuestaDatos, function (i, Datos) {
                                                if (Fila.Numero == Datos.Numero && Fila.IdHistoriaClinica == Datos.IdHistoriaClinica) {
                                                    Contenido += "<tr><td align='left'>" + Datos.NombreServicio + "</td><td align='left'>" + Datos.Observaciones + "</td><td align='center'>" + Datos.Cantidad + "</td></tr>"
                                                }
                                            });
                                            Contenido += "</tbody></table></fieldset><br>"
                                        }
                                    });
                                    Contenido += "</fieldset><br><br>"
                                });

                                // Ordenes de Remisiones a Especialistas
                            } else if (TipoOrden == "OR") {

                                $.each(RespuestaEncabezado, function (i, Encabezado) {
                                    Contenido += "<fieldset><legend> Atención N° " + Encabezado.IdHistoriaClinica + " del " + Encabezado.Fecha + " por el profesional " + Encabezado.LoginProfesional + "</legend>"
                                    $.each(RespuestaCuerpo, function (i, Fila) {
                                        if (Encabezado.IdHistoriaClinica == Fila.IdHistoriaClinica) {
                                            Contenido += "<fieldset style='border:none;text-align: left;'><legend>Orden de Remisión a Especialidad Número " + Fila.Numero + "</legend>"
                                            Contenido += "<table class='Tabla'><thead><tr><th style='width: 450px'>Nombre de la Especialidad</th><th style='width: 465px'>Motivo de la Remisión</th></tr></thead><tbody>"
                                            $.each(RespuestaDatos, function (i, Datos) {
                                                if (Fila.Numero == Datos.Numero && Fila.IdHistoriaClinica == Datos.IdHistoriaClinica) {
                                                    Contenido += "<tr><td align='left'>" + Datos.NombreEspecilidad + "</td><td align='left'>" + Datos.MotivoRemision + "</td></tr>"
                                                }
                                            });
                                            Contenido += "</tbody></table></fieldset><br>"
                                        }
                                    });
                                    Contenido += "</fieldset><br><br>"
                                });

                                //Ordenes de Incapacidades
                            } else if (TipoOrden == "OI") {

                                $.each(RespuestaEncabezado, function (i, Encabezado) {
                                    Contenido += "<fieldset><legend> Atención N° " + Encabezado.IdHistoriaClinica + " del " + Encabezado.Fecha + " por el profesional " + Encabezado.LoginProfesional + "</legend>"
                                    $.each(RespuestaCuerpo, function (i, Fila) {
                                        if (Encabezado.IdHistoriaClinica == Fila.IdHistoriaClinica) {
                                            Contenido += "<fieldset style='border:none;text-align: left;'><legend>Orden de Incapacidad Número " + Fila.Numero + "</legend>"
                                            Contenido += "<table class='Tabla' ><thead><tr><th style='width: 750px'>Motivo de la Incapacidad</th><th style='width: 100px'>Dias</th><th style='width: 100px'>Tipo</th></tr></thead><tbody>"
                                            $.each(RespuestaDatos, function (i, Datos) {
                                                if (Fila.Numero == Datos.Numero && Fila.IdHistoriaClinica == Datos.IdHistoriaClinica) {
                                                    Contenido += "<tr><td align='left'>" + Datos.MotivoIncapacidad + "</td><td align='center'>" + Datos.DiasIncapacidad + "</td><td align='center'>" + Datos.Tipo + "</td></tr>"
                                                }
                                            });
                                            Contenido += "</tbody></table></fieldset><br>"
                                        }
                                    });
                                    Contenido += "</fieldset><br><br>"
                                });

                                // Ordenes de Certificaciones
                            } else if (TipoOrden == "OC") {

                                $.each(RespuestaEncabezado, function (i, Encabezado) {
                                    Contenido += "<fieldset><legend> Atención N° " + Encabezado.IdHistoriaClinica + " del " + Encabezado.Fecha + " por el profesional " + Encabezado.LoginProfesional + "</legend>"
                                    $.each(RespuestaCuerpo, function (i, Fila) {
                                        if (Encabezado.IdHistoriaClinica == Fila.IdHistoriaClinica) {
                                            Contenido += "<fieldset style='border:none;text-align: left;'><legend>Orden de Certificación Número " + Fila.Numero + "</legend>"
                                            Contenido += "<table class='Tabla' ><thead><tr><th style='width: 950px'>Certificacion</th></tr></thead><tbody>"
                                            $.each(RespuestaDatos, function (i, Datos) {
                                                if (Fila.Numero == Datos.Numero && Fila.IdHistoriaClinica == Datos.IdHistoriaClinica) {
                                                    Contenido += "<tr><td align='left'>" + Datos.DescripcionCertificacion + "</td></tr>"
                                                }
                                            });
                                            Contenido += "</tbody></table></fieldset><br>"
                                        }
                                    });
                                    Contenido += "</fieldset><br><br>"
                                });
                            }


                            document.getElementById("ContenidoPnHistorico").innerHTML = Contenido;
                        }
                        else {
                            document.getElementById("ContenidoPnHistorico").innerHTML = "<table class='Tabla' style='width:100%;'><thead><tr><th>Historico</th></tr></thead><tbody><tr><td class='TextoAlCentro'>Sin datos en las atenciones anteriores</td></tr></tbody></table>";
                        }
                        $find("MpePnHistoricoOrdenes").show();
                        Progreso(false);
                    },
                    error: function (Respuesta) { Progreso(false); Mensaje("Error", JSON.parse(Respuesta.responseText).Message) }
                });




            }
        }

        function HistoricoCampos(Campo) {
            if ($get("HdfIdHistoriaClinica").value != "") {
                Progreso(true);
                $.ajax({
                    type: "POST",
                    data: "{ 'IdHistoriaClinica': '" + $get("HdfIdHistoriaClinica").value +
                          "','Campo': '" + Campo +
                        "'}",
                    url: NombreFormulario() + "/HistoriaClinica_HistoriasClinicasHistoricoCamposSelecciona",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (Respuesta) {
                        var RespuestaEncabezado = JSON.parse(Respuesta.d).Table;
                        var Contenido = "";
                        document.getElementById("ContenidoPnHistoricoCampos").innerHTML = "";
                        if (RespuestaEncabezado.length > 0) {
                            $.each(RespuestaEncabezado, function (i, Encabezado) {
                                Contenido += "<fieldset><legend> Atención N° " + Encabezado.IdHistoriaClinica + " del " + Encabezado.Fecha + " por el profesional " + Encabezado.LoginProfesional + "</legend>"
                                Contenido += "<fieldset style='border:none;text-align: left;'><legend></legend>"
                                Contenido += "<table class='Tabla'><thead><tr><th style='width: 970px'>" + (Campo == "MC" ? "Motivo de Consulta" : (Campo == "EA" ? "Enfermedad Actual" : "Plan de Tratamiento")) + "</th></tr></thead><tbody>"
                                Contenido += "<tr><td align='left'>" + Encabezado.Campo + "</td></tr>"
                                Contenido += "</tbody></table></fieldset><br>"
                                Contenido += "</fieldset><br>"
                            });
                            document.getElementById("ContenidoPnHistoricoCampos").innerHTML = Contenido;
                        }
                        else {
                            document.getElementById("ContenidoPnHistoricoCampos").innerHTML = "<table class='Tabla' style='width:100%;'><thead><tr><th>Historico</th></tr></thead><tbody><tr><td class='TextoAlCentro'>Sin datos en las atenciones anteriores</td></tr></tbody></table>";
                        }
                        $find("MpePnHistoricoCampos").show();
                        Progreso(false);
                    },
                    error: function (Respuesta) { Progreso(false); Mensaje("Error", JSON.parse(Respuesta.responseText).Message) }
                });

            }
            return false;
        }


        //Ver los paraclinicos  INICIO

        function VerParaclinico(ParaclinicoId) {
            if (ParaclinicoId == "")
                Mensaje("informacion", "Éste examen paraclínico, aún no se ha realizado");
            else if (ParaclinicoId == "NO ENLAZADO")
                Mensaje("informacion", "Examen paraclínico, NO ENLAZADO en el sistema");
            else {
                ParaclinicoId = ParaclinicoId.split("|");
                var Reporte = "";
                switch (ParaclinicoId[1]) {
                    case "Audiometria":
                    case "ExamenVisual":
                    case "EvaluacionOptometria":
                    case "Espirometria":
                        Reporte = '../HistoriaClinica/' + ParaclinicoId[1] + '.ashx?Id=' + ParaclinicoId[0] + "&rd=" + Math.random();
                        break;
                    case "Laboratorios":
                        Reporte = '../Laboratorio/' + ParaclinicoId[1] + '.html?Id=' + ParaclinicoId[0] + "&rd=" + Math.random();
                        break;
                    case "Osteomusculares":
                        Reporte = '../HistoriaClinica/' + ParaclinicoId[1] + '.ashx?Id=' + ParaclinicoId[0] + "&rd=" + Math.random();
                        break;
                    default:
                        var Ruta = ParaclinicoId[1].split(".")[0];
                        var Extension = ParaclinicoId[1].split(".")[1];
                        Reporte = '../HistoriaClinica/' + Ruta + '/' + ParaclinicoId[0] + "." + Extension + "?rd=" + Math.random();
                        break;
                }
                open(Reporte, 'Tik', 'top=0,left=10,width=850,height=700,status=yes,resizable=no,scrollbars=yes');
            }
            return false;
        }

        //Ver los paraclinicos FIN


        function Errores(Excepcion) { Progreso(false); Mensaje("Fallo", Excepcion.get_message()); return false; }
    </script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="N" runat="Server">
    Consulta Externa
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="B" runat="Server">
    <asp:BarraHerramientas ID="BH" runat="server" BotonBuscar="True" BotonImprimir="True" BotonAnular="True" BotonAprobar="True" />

    <table>
        <tr>
            <td onclick="return ImprimirEvolucion();" class="BHEnabled" id="BH_TdEvoluciones">
                <asp:ImageButton ID="ImageButton1"
                    alt="Imprimir Evoluciones" ToolTip="Imprimir Evoluciones"
                    runat="server" ImageUrl="~/Imagenes/OrdenServicio.png" /><br />
                Evoluciones
            </td>
        </tr>
    </table>
    <div style="float: right; padding-top: 7px;">
        <span style="color: #FFFFFF; font-size: 30px; font-weight: bold; padding-bottom: 20px;"
            id="SpanIdHistoriaClinica"></span><span style="color: #FFFFFF; font-size: 30px; font-weight: bold; padding-bottom: 20px;"
                id="SpanEstado"></span>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="C" runat="Server">
    <asp:HiddenField ID="HdfIdOrdenServicioControl" runat="server" ClientIDMode="Static" />
    <div id="p0" runat="server">
        <script type="text/javascript">            //timerID = setTimeout("MostrarCantPaci()", 1000);</script>
        <asp:HiddenField ID="HdfEstado" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HdfIdHistoriaClinica" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HdfIdHistoriaClinicaTemp" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HdfIdOrdenServicio" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HdfHistoricoDiagnostico" runat="server" ClientIDMode="Static" />
        <%--<img alt="" onclick="Prueba();" src="" />--%>
        <%--<input  value='' type='hidden' />--%>
        <table>
            <tr>
                <td>


                    <table>
                        <tr>
                            <td>Tipo<br>
                                <div class="radio" style="width: 80px;">
                                    <input clientidmode="Static" runat="server" type='radio' checked="true" id="EG" name="TipoConsulta" /><label for="EG">EG</label>
                                    <input clientidmode="Static" runat="server" type='radio' id="AL" name="TipoConsulta" /><label for="AL">AL</label>
                                </div>
                            </td>
                            <td>Municipio:
     <br />
                                <asp:TextBox ID="TxtMunicipio" runat="server" Width="295px" ClientIDMode="Static" />
                                <asp:HiddenField ID="HdfMunicipio" runat="server" ClientIDMode="Static" />
                                <asp:AutoCompleteExtender ID="AceTxtMunicipio" runat="server" MinimumPrefixLength="1"
                                    TargetControlID="TxtMunicipio" ServiceMethod="NombresMunicipiosAutocomplete" FirstRowSelected="True"
                                    CompletionListCssClass="ContenedorLista" CompletionListItemCssClass="ItemLista"
                                    CompletionInterval="1" CompletionListHighlightedItemCssClass="SeleccionItemLista"
                                    OnClientItemSelected="AsignarCodigoMunicipio" BehaviorID="AceTxtMunicipio" UseContextKey="True"
                                    DelimiterCharacters="" Enabled="True" ServicePath="">
                                </asp:AutoCompleteExtender>
                            </td>
                            <td>Fecha:<br />
                                <asp:TextBox ID="TxtFecha" runat="server" Width="75px" ClientIDMode="Static" />
                                <asp:FilteredTextBoxExtender ID="FtTxtFecha" runat="server" Enabled="True" FilterType="Custom, Numbers"
                                    TargetControlID="TxtFecha" ValidChars="/"></asp:FilteredTextBoxExtender>
                                <asp:CalendarExtender ID="CetTxtFecha" runat="server" Enabled="True" PopupPosition="BottomRight"
                                    TargetControlID="TxtFecha"></asp:CalendarExtender>
                            </td>

                            <td>Empresa:<br />
                                <asp:TextBox ID="TxtEmpresa" onkeydown="return false;" runat="server" CssClass="readonly"
                                    Width="368px" ClientIDMode="Static" />
                            </td>
                        </tr>
                    </table>
                    <table>
                        <tr>
                            <td>Tipo:<br />
                                <asp:TextBox ID="TxtTipo" onkeydown="return false;" runat="server" CssClass="readonly"
                                    Width="30PX" ClientIDMode="Static" />
                            </td>
                            <td>Numero Identificación:<br />
                                <asp:TextBox ID="TxtNumeroIdentificacion" onkeydown="return false;" runat="server"
                                    CssClass="readonly" Width="140px" ClientIDMode="Static" />
                            </td>
                            <td>Nombre:<br />
                                <asp:TextBox ID="TxtNombre" onkeydown="return false;" runat="server" CssClass="readonly"
                                    Width="355px" ClientIDMode="Static" />
                                <asp:HiddenField ID="HdfGenero" runat="server" ClientIDMode="Static" />
                            </td>
                            <td>Genero<br />
                                <asp:TextBox ID="TxtGenero" onkeydown="return false;" runat="server"
                                    CssClass="readonly" Width="90px" ClientIDMode="Static" />
                            </td>
                            <td>Edad:<br />
                                <asp:TextBox ID="TxtEdad" onkeydown="return false;" runat="server" CssClass="readonly"
                                    Width="80PX" ClientIDMode="Static" />
                            </td>
                            <td>Estado Civil:<br />
                                <asp:TextBox ID="TxtEstadoCivil" onkeydown="return false;" runat="server" CssClass="readonly"
                                    Width="115PX" ClientIDMode="Static" />
                            </td>

                        </tr>
                    </table>
                    <table>
                        <tr>
                            <td>Nivel Educativo:<br />
                                <asp:TextBox ID="TxtNivelEducativo" onkeydown="return false;" runat="server" CssClass="readonly"
                                    Width="140PX" ClientIDMode="Static" />
                            </td>
                            <td>Tipo Evaluación Medica:<br />
                                <asp:TextBox ID="TxtTipoEvaluacionMedica" onkeydown="return false;" runat="server"
                                    CssClass="readonly" Width="695px" ClientIDMode="Static" />
                            </td>
                        </tr>
                    </table>
                    <table>
                        <tr>
                            <td>Cargo:<br />
                                <asp:TextBox ID="TxtCargo" onkeydown="return false;" runat="server" CssClass="readonly"
                                    Width="230px" ClientIDMode="Static"></asp:TextBox>
                            </td>
                            <td>Funciones del Cargo:<br />
                                <asp:TextBox ID="TxtFuncionesdeCargo" onkeydown="return false;" runat="server" CssClass="readonly"
                                    Width="220px " ClientIDMode="Static"></asp:TextBox>
                            </td>
                            <td>Eps:<br />
                                <asp:TextBox ID="TxtEps" onkeydown="return false;" runat="server" CssClass="readonly"
                                    Width="125px" ClientIDMode="Static"></asp:TextBox>
                            </td>
                            <td>Afp:<br />
                                <asp:TextBox ID="TxtAfp" onkeydown="return false;" runat="server" CssClass="readonly"
                                    Width="120px" ClientIDMode="Static"></asp:TextBox>
                            </td>
                            <td>Arl:<br />
                                <asp:TextBox ID="TxtArl" onkeydown="return false;" runat="server" CssClass="readonly"
                                    Width="120px" ClientIDMode="Static"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </td>
                <td>
                    <img id="ImgFoto" style="width: 115px; height: 115px; margin-left: 10px;" src="../Imagenes/Silueta.png" />
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td>Motivo de Consulta: <span style="font-size: 9px;" onclick="HistoricoCampos('MC');">&nbsp;&nbsp;&nbsp;&nbsp;<img src="../Imagenes/AbrirCarpeta.png" style="width: 15px;"></span><br />
                    <asp:TextBox ID="TxtMotivoConsulta" ClientIDMode="Static" runat="server" Width="500px" Height="40px" TextMode="MultiLine"></asp:TextBox>
                </td>
                <td>Enfermedad Actual: <span style="font-size: 9px;" onclick="HistoricoCampos('EA');">&nbsp;&nbsp;&nbsp;&nbsp;<img src="../Imagenes/AbrirCarpeta.png" style="width: 15px;"></span><br />
                    <asp:TextBox ID="TxtPadecimientoActual" ClientIDMode="Static" runat="server" Width="475px" Height="40px" TextMode="MultiLine"></asp:TextBox>
                </td>
            </tr>
        </table>
    </div>
    <asp:TabContainer runat="server" ID="TcHco" ClientIDMode="Static" Width="998" ScrollBars="None" ActiveTabIndex="0">
        <asp:TabPanel runat="server" ID="TpHa">
            <HeaderTemplate>
                Historia de antecedentes
            </HeaderTemplate>
            <ContentTemplate>
                <div id="p1" runat="server">
                    <asp:HiddenField ID="HdfAntecedentes" runat="server" ClientIDMode="Static" />
                    <div id="DivAntecedentes" clientidmode="Static" runat="server">
                    </div>
                    <br />
                    <br />
                </div>
            </ContentTemplate>
        </asp:TabPanel>
        <asp:TabPanel runat="server" ID="TpRs">
            <HeaderTemplate>
                Revisión por Sistemas
    <br />
                y Hábitos
            </HeaderTemplate>
            <ContentTemplate>
                <div id="p2" runat="server">
                    <asp:HiddenField ID="HdfRevisionesSistemas" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="Hdfhabitos" runat="server" ClientIDMode="Static" />
                    <div id="Rs" runat="server">
                    </div>


                    <br />
                    <br />
                </div>
            </ContentTemplate>
        </asp:TabPanel>
        <asp:TabPanel runat="server" ID="TpEf">
            <HeaderTemplate>
                Examen Físico
            </HeaderTemplate>
            <ContentTemplate>
                <div id="p3" runat="server">
                    <fieldset class="FSignosVitales">
                        <legend>SIGNOS VITALES</legend>
                        <asp:HiddenField ID="HdfExamenFisico" runat="server" ClientIDMode="Static" />
                        Tensión Arterial (mm Hg)
       <table>
           <tr>
               <td><span style="font-size: 10px;">Sistólica</span>
                   <br />
                   <asp:TextBox ID="TxtSistolica" onchange="ClasificarHTA();" onKeyPress="return esEntero(event);" runat="server"
                       Width="50px" ClientIDMode="Static" MaxLength="3" CssClass="TextoAlCentro"></asp:TextBox>
               </td>
               <td><span style="font-size: 10px;">Diastólica</span>
                   <br />
                   /<asp:TextBox ID="TxtDiastolica" onchange="ClasificarHTA();" onKeyPress="return esEntero(event);" runat="server"
                       Width="50px" ClientIDMode="Static" MaxLength="3" CssClass="TextoAlCentro"></asp:TextBox>
               </td>
               <td><span style="font-size: 10px;">Clasificación</span><br />
                   <asp:TextBox ID="TxtClasificacionHTA" runat="server" ClientIDMode="Static" Width="185px" ReadOnly="True"></asp:TextBox>
               </td>
               <td><span style="font-size: 10px;">F. Cardiaca (x min)</span><br />
                   <asp:TextBox ID="TxtFCardiaca" onKeyPress="return esEntero(event);" runat="server"
                       ClientIDMode="Static" Width="100px" MaxLength="3" CssClass="TextoAlCentro"></asp:TextBox>
               </td>
               <td><span style="font-size: 10px;">F. Respiratoria (x min)</span><br />
                   <asp:TextBox ID="TxtFRespiratoria" onKeyPress="return esEntero(event);" runat="server"
                       ClientIDMode="Static" Width="110px" MaxLength="3" CssClass="TextoAlCentro"> </asp:TextBox>
               </td>
               <td><span style="font-size: 10px;">Pulsioximetría (%)</span><br />
                   <asp:TextBox ID="TxtPulsioximetria" onKeyPress="return esEntero(event);" runat="server"
                       ClientIDMode="Static" Width="110px" MaxLength="2" CssClass="TextoAlCentro"> </asp:TextBox>
               </td>

               <td><span style="font-size: 10px;">Temperatura (°C)</span><br />
                   <asp:TextBox ID="TxtTemperatura" onKeyPress="return esInteger(event);" MaxLength="5" CssClass="TextoAlCentro" runat="server"
                       ClientIDMode="Static" Width="120px"></asp:TextBox>
               </td>
               <td><span style="font-size: 10px;">Lateralidad Dominante</span><br />
                   <asp:DropDownList ID="CbLateralidadDominante" runat="server" ClientIDMode="Static"
                       Width="177px">
                       <asp:ListItem Text="DIESTRO" Value="DIESTRO"></asp:ListItem>
                       <asp:ListItem Text="ZURDO" Value="ZURDO"></asp:ListItem>
                       <asp:ListItem Text="AMBIDIESTRO" Value="AMBIDIESTRO"></asp:ListItem>
                   </asp:DropDownList>
               </td>
           </tr>
       </table>
                        <table>
                            <tr>
                                <td>Peso (kg)<br />
                                    <asp:TextBox ID="TxtPeso" onKeyPress="return esInteger(event);" onchange="CalculaIMC();"
                                        runat="server" ClientIDMode="Static" Width="70px"></asp:TextBox>
                                </td>
                                <td>Talla (cm)<br />
                                    <asp:TextBox ID="TxtTalla" onKeyPress="return esEntero(event);" onchange="CalculaIMC();"
                                        runat="server" ClientIDMode="Static" Width="80px" MaxLength="3" CssClass="TextoAlCentro"></asp:TextBox>
                                </td>
                                <td>Índice de masa corporal(IMC)<br />
                                    <asp:TextBox ID="TxtImc" runat="server" ClientIDMode="Static" Width="372px" ReadOnly="True"></asp:TextBox>
                                </td>
                                <td>Perímetro Abdominal(cm)<br />
                                    <asp:TextBox ID="TxtPerimeroAbdominal" onKeyPress="return esEntero(event);" onchange="InerpretacionPerimeroAbdominal();"
                                        runat="server" ClientIDMode="Static" Width="180px" MaxLength="3" CssClass="TextoAlCentro"></asp:TextBox>
                                </td>
                                <td>Interpretación Perímetro Abdominal<br />
                                    <asp:TextBox ID="TxtInerpretacionPerimeroAbdominal" runat="server" ClientIDMode="Static"
                                        ReadOnly="True" Width="240px"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                    <div id="Ef" runat="server">
                    </div>
                    <br />
                    <br />
                </div>
            </ContentTemplate>
        </asp:TabPanel>
        <asp:TabPanel runat="server" ID="TpPD">
            <HeaderTemplate>
                Paraclinicos y Diagnósticos
            </HeaderTemplate>
            <ContentTemplate>
                <div id="p4" runat="server">
                    <asp:HiddenField ID="HdfParaclinicosSolicitados" runat="server" ClientIDMode="Static" />
                    <fieldset>
                        <legend>Procedimientos realizados en la IPS</legend>
                        <div id="Pd" runat="server">
                        </div>
                    </fieldset>

                    <br />
                    <fieldset id="FDocumentosExternos" runat="server">
                        <legend>Exámenes Diagnósticos y Documentos Externos en Ésta Atención</legend>
                        <table>
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
                    <br />

                    Observaciones Paraclínicos
     <asp:TextBox ID="TxtObservacionesParaclinicos" runat="server" ClientIDMode="Static"
         TextMode="MultiLine" Width="975px" Height="50px"></asp:TextBox>
                    <asp:Diagnosticos runat="server" ID="CuDiagnosticos" />
                    <br />
                    <br />
                </div>
            </ContentTemplate>
        </asp:TabPanel>

        <asp:TabPanel runat="server" ID="TpPlanTerapeutico">
            <HeaderTemplate>
                Plan de Tratamiento
            </HeaderTemplate>
            <ContentTemplate>
                <div id="p5" runat="server">
                    Describa el plan de tratamiento:<span style="font-size: 9px;" onclick="HistoricoCampos('PT');">&nbsp;&nbsp;&nbsp;&nbsp;<img src="../Imagenes/AbrirCarpeta.png" style="width: 15px;"></span><br />
                    <asp:TextBox ID="TxtPlanTerapeutico" runat="server" ClientIDMode="Static"
                        TextMode="MultiLine" Width="975px" Height="220px"></asp:TextBox>
                </div>
            </ContentTemplate>
        </asp:TabPanel>

        <%--Juan--%>
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
                                        Agregar
                                    </td>
                                    <td class="BHEnabledBuscar" onclick="HistoricoOrdenes('OM');" style="cursor: pointer;">
                                        <img src="../Imagenes/AbrirCarpeta.png" style="width: 20px;" />
                                        Historico
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
                                        Agregar
                                    </td>
                                    <td class="BHEnabledBuscar" onclick="HistoricoOrdenes('OS');" style="cursor: pointer;">
                                        <img src="../Imagenes/AbrirCarpeta.png" style="width: 20px;" />
                                        Historico
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
                                        Agregar
                                    </td>
                                    <td class="BHEnabledBuscar" onclick="HistoricoOrdenes('OR');" style="cursor: pointer;">
                                        <img src="../Imagenes/AbrirCarpeta.png" style="width: 20px;" />
                                        Historico
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
                                        Agregar
                                    </td>
                                    <td class="BHEnabledBuscar" onclick="HistoricoOrdenes('OI');" style="cursor: pointer;">
                                        <img src="../Imagenes/AbrirCarpeta.png" style="width: 20px;" />
                                        Historico
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
                                            <img alt="" src="../Imagenes/Guardar.png" onclick="GuardarOrdenIncapacidad();" id="Img8"
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
                                            <img alt="" src="../Imagenes/ImprimirBlanco.png" onclick="return ImprimeOrdenIncapacidades();" id="Img9"
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
                                        Agregar
                                    </td>
                                    <td onclick="GuardarOrdenCertificacion();" class="BHEnabledBuscar" style="cursor: pointer;">
                                        <img src="../Imagenes/Guardar.png" style="width: 20px;" />
                                        Guardar
                                    </td>
                                    <td onclick="ImprimeOrdenCertificacion();" class="BHEnabledBuscar" style="cursor: pointer;">
                                        <img src="../Imagenes/Imprimir.png" style="width: 20px;" />
                                        Imprimir
                                    </td>
                                    <td class="BHEnabledBuscar" onclick="HistoricoOrdenes('OC');" style="cursor: pointer;">
                                        <img src="../Imagenes/AbrirCarpeta.png" style="width: 20px;" />
                                        Historico
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



        <asp:TabPanel runat="server" ID="TpEM">
            <HeaderTemplate>
                Evoluciones
            </HeaderTemplate>
            <ContentTemplate>
                <div id="p8" runat="server">

                    <asp:HiddenField ID="HdfEvolucionMedica" ClientIDMode="Static" runat="server" />
                    <table>
                        <tr>
                            <td>Fecha y hora de la Evolución:<br />
                                <asp:TextBox ID="TxtFechaEvolucion" runat="server" Width="87px" ClientIDMode="Static" AutoComplete="off" />
                                <asp:FilteredTextBoxExtender ID="FtTxtFechaEvolucion" runat="server" Enabled="True" FilterType="Custom, Numbers" TargetControlID="TxtFechaEvolucion" ValidChars="/"></asp:FilteredTextBoxExtender>
                                <asp:CalendarExtender ID="CetTxtFechaEvolucion" runat="server" Enabled="True" PopupPosition="BottomRight" TargetControlID="TxtFechaEvolucion"></asp:CalendarExtender>
                                <asp:DropDownList ID="CbHora" runat="server" ClientIDMode="Static" Width="70px">
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
                                <asp:DropDownList ID="CbMinutos" runat="server" ClientIDMode="Static" Width="85px">
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
                            <td>Evolución<br />
                                <asp:TextBox ID="TxtEvolucion" ClientIDMode="Static" Width="958px" Height="80px" runat="server" TextMode="MultiLine"></asp:TextBox>
                            </td>
                            <td>
                                <input type="image" id="BtnAgregarEvolucion" src="../Imagenes/Guardar.png"
                                    alt="" title="Agregar Evolucion" value="button" onclick="return GuardarEvolucion()" />
                            </td>
                        </tr>
                    </table>
                    <table class="Tabla" id="TbEvoluciones" runat="server" clientidmode="Static">
                        <tr>
                            <th style="width: 90px">Fecha
                            </th>
                            <th style="width: 300px">Profesional Asistencial
                            </th>
                            <th style="width: 530px">Evolución
                            </th>
                            <th style="font-size: 13px; width: 13px;">
                                <input type="checkbox" /></th>
                        </tr>
                    </table>
                </div>
            </ContentTemplate>
        </asp:TabPanel>
    </asp:TabContainer>
    <div id="Monitoreo">
        <asp:Panel ID="PnMonitoreo" CssClass="Encabezado" runat="server" ToolTip="Mostrar/Ocultar Pacientes"
            Width="100%" Style="cursor: pointer;">
            <asp:Image ID="ImgBajarSubir" runat="server" ImageUrl="~/Imagenes/Subir.png" />
            <span id="CantidadPacientes">Cargando pacientes pendientes por atender para el día: <%= Me.TxtFechaAtencion.Text%>.</span>
        </asp:Panel>
        <asp:Panel ID="PnGvTurnos" runat="server" Style="visibility: collapse; overflow: auto; display: none; width: 1060px;">
            <div style="overflow-y: scroll; width: 100%; height: 295px;">
                <asp:HiddenField ID="HdfIdTurno" runat="server" ClientIDMode="Static" />
                <table id="TbTurnos" style="width: 100%" class="Tabla">
                    <tr>
                        <th style="width: 80px;">
                            <asp:Image Style="cursor: pointer;" CssClass="Invisible" ID="ImgCalendario" onclick="AbrirCalendario();" runat="server" ImageUrl="~/Imagenes/Calendario.png" Width="24px" />
                            <asp:TextBox ID="TxtFechaAtencion" onchange="OcultarCalendario();" Width="80px" CssClass="TextoAlCentro" ClientIDMode="Static" runat="server"></asp:TextBox>
                            <asp:CalendarExtender ID="CeTxtFechaAtencion" runat="server" Enabled="True" PopupPosition="Right"
                                TargetControlID="TxtFechaAtencion"></asp:CalendarExtender>
                        </th>
                        <th>Estado</th>
                        <th>Producto</th>
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


    <asp:Panel ID="PnHistoricoOrdenes" runat="server" Style="display: none;" CssClass="VentanModal">
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
                <span id="TituloPnHistorico">Histórico de Órdenes Médicas</span>
                <input id="BtnCerrarPnHistoricoOrdenes" runat="server" alt="" src="~/Imagenes/BotonCerrarMensajes.png"
                    onmouseout="RestablecerImagen(this);" onmouseover="CambiarImagen(this);" class="CerrarMensaje"
                    type="image" />
            </div>
            <div class="VentanModal-Contenido" id="ContenidoPnHistorico" style="width: 990px; min-width: 500px; height: 500px;">
            </div>
            <div class="cleared">
            </div>
        </div>
    </asp:Panel>
    <asp:ModalPopupExtender ID="MpePnHistoricoOrdenes" runat="server" Enabled="True" TargetControlID="HdfPnHistoricoOrdenes"
        CancelControlID="BtnCerrarPnHistoricoOrdenes" BackgroundCssClass="VentanModal-Fondo" PopupControlID="PnHistoricoOrdenes"
        BehaviorID="MpePnHistoricoOrdenes" Y="30">
    </asp:ModalPopupExtender>
    <asp:Label ID="HdfPnHistoricoOrdenes" runat="server"></asp:Label>


    <asp:Panel ID="PnHistoricoCampos" runat="server" Style="display: none;" CssClass="VentanModal">
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
                <span id="TituloPnHistoricoCampos">Histórico</span>
                <input id="BtnCerrarPnHistoricoCampos" runat="server" alt="" src="~/Imagenes/BotonCerrarMensajes.png"
                    onmouseout="RestablecerImagen(this);" onmouseover="CambiarImagen(this);" class="CerrarMensaje"
                    type="image" />
            </div>
            <div class="VentanModal-Contenido" id="ContenidoPnHistoricoCampos" style="width: 990px; min-width: 500px; height: 500px;">
            </div>
            <div class="cleared">
            </div>
        </div>
    </asp:Panel>
    <asp:ModalPopupExtender ID="MpePnHistoricoCampos" runat="server" Enabled="True" TargetControlID="HdfPnHistoricoCampos"
        CancelControlID="BtnCerrarPnHistoricoCampos" BackgroundCssClass="VentanModal-Fondo" PopupControlID="PnHistoricoCampos"
        BehaviorID="MpePnHistoricoCampos" Y="30">
    </asp:ModalPopupExtender>
    <asp:Label ID="HdfPnHistoricoCampos" runat="server"></asp:Label>

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
                        <td>N° de Atención<br />
                            <asp:TextBox ID="BuscaNoHistoriaClinica" ClientIDMode="Static" runat="server" Width="120px" onkeydown="if(event.keyCode==13) { BuscarVacio(); return false;}"></asp:TextBox>
                        </td>
                        <td>N° de Identificación:<br />
                            <asp:TextBox ID="BuscaNumeroIdentificacion" runat="server" Width="140px" ClientIDMode="Static" onkeydown="if(event.keyCode==13) { BuscarVacio(); return false;}" />
                        </td>
                        <td>Nombre del Paciente:<br />
                            <asp:TextBox ID="BuscaCliente" runat="server" AutoComplete="off" ClientIDMode="Static"
                                Width="420px" onkeydown="if(event.keyCode==13) { BuscarVacio(); return false;}" placeholder="Escriba parte del nombre o apellido para filtrar" />
                        </td>
                        <td>
                            <table class="Botones">
                                <tr>
                                    <td runat="server" id="TdBuscar" class="BHEnabledBuscar">
                                        <asp:ImageButton ID="BtnAceptaBuscar" runat="server" OnClientClick="return BuscarVacio();"
                                            ToolTip="Realizar busqueda de registros" CausesValidation="False" ImageUrl="~/Imagenes/Buscar.png"
                                            Enabled="True" /><br />
                                        Busca
                                    </td>
                                </tr>
                            </table>
                        </td>

                    </tr>
                </table>
                <div style="width: 100%; text-align: left">
                    <table class="Tabla">
                        <tr>
                            <th style="width: 30px"></th>
                            <th style="width: 130px">N° de Atención
                            </th>
                            <th style="width: 150px">N° de Identificación
                            </th>
                            <th style="width: 400px">Nombre del Paciente
                            </th>
                            <th style="width: 100px">Fecha
                            </th>
                        </tr>
                    </table>
                    <div style="overflow-y: scroll; width: 880px; height: 400px">
                        <asp:GridView ID="GvHistoriaClinicaBuscar" runat="server" AutoGenerateColumns="False"
                            CssClass="Tabla" DataKeyNames="IdHistoriaClinica" DataSourceID="SqlDsHistoriaClinica"
                            ShowHeader="False">
                            <Columns>
                                <asp:TemplateField ShowHeader="False" ItemStyle-Width="30px" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="BtnSeleccionarGv" runat="server" CausesValidation="False" CommandName="Select"
                                            ImageUrl="~/Imagenes/seleccionar.png" Text="Seleccionar" />
                                    </ItemTemplate>
                                    <ItemStyle Width="30px"></ItemStyle>
                                </asp:TemplateField>
                                <asp:BoundField DataField="IdHistoriaClinica" HeaderText="IdHistoriaClinica" ReadOnly="True"
                                    SortExpression="IdHistoriaClinica" ItemStyle-Width="130px" ItemStyle-HorizontalAlign="Center">
                                    <ItemStyle Width="130px"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="NumeroIdentificacion" HeaderText="NumeroIdentificacion"
                                    ReadOnly="True" SortExpression="NumeroIdentificacion" ItemStyle-Width="150px" ItemStyle-HorizontalAlign="Center">
                                    <ItemStyle Width="150px"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="Nombre" HeaderText="Nombre" ReadOnly="True" SortExpression="Nombre"
                                    ItemStyle-Width="400px">
                                    <ItemStyle Width="400px"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="FechaCreacion" HeaderText="FechaCreacion" SortExpression="FechaCreacion"
                                    ItemStyle-Width="100px" DataFormatString="{0:d}" ItemStyle-HorizontalAlign="Center">
                                    <ItemStyle Width="100px"></ItemStyle>
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
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
            <div class="VentanModal-Contenido" style="height: 90px; padding: 20px;">
                <div style="width: 100%; text-align: center; font-size: 20px;">
                    ¿Qué tipo de Atención se va a prestar?
     
     <table style="width: 450px; margin: 20px auto;">
         <tr>
             <td>
                 <input type="button" onclick="return AtencionPrimeraVez();" class="BtnVerde" value="Atención por Primera Vez" />
             </td>
             <td>
                 <input type="button" onclick="return AtencionControl();" class="BtnAzul" value="Atención por Control" />
             </td>
         </tr>
     </table>
                </div>
            </div>
            <div class="cleared">
            </div>
        </div>
    </asp:Panel>

    <asp:ModalPopupExtender ID="MpePnEvolucion" runat="server" Enabled="True" TargetControlID="HdfEvolucionControl"
        CancelControlID="BtnCerrarEvolucion" PopupControlID="PnEvolucion" BackgroundCssClass="VentanModal-Fondo"
        BehaviorID="MpePnEvolucion" Y="200">
    </asp:ModalPopupExtender>
    <asp:Label ID="HdfEvolucionControl" runat="server"></asp:Label>


    <asp:SqlDataSource ID="SqlDsHistoriaClinica" runat="server" ConnectionString="<%$ ConnectionStrings:ConexionBD %>"
        SelectCommand="HistoriaClinica.HistoriasClinicasBusqueda" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:Parameter Name="Nombre" Type="String" />
            <asp:Parameter Name="NumeroIdentificacion" Type="String" />
            <asp:Parameter Name="IdHistoriaClinica" Type="String" />
            <asp:Parameter Name="TipoHistoria" Type="String" DefaultValue="GENERAL" />
        </SelectParameters>
    </asp:SqlDataSource>
    <%-- </div>--%>
</asp:Content>

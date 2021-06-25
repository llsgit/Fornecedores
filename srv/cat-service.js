const cds = require("@sap/cds");
const axios = require("axios");

module.exports = cds.service.impl(function () {    
    const {OrdemServicos}   = cds.entities('com.portal.OrdemServicos');    
    const {NotasFiscais}    = cds.entities('com.portal.NotasFiscais');    
    const {CurrentUser}     = cds.entities('com.portal.CurrentUser');    
    const {Defeitos}        = cds.entities('com.portal.Defeitos');    
    const {Historicos}      = cds.entities('com.portal.Historicos');  
    const numberOfDaysToSubstract = 30;     
    this.before('READ', "Defeitos", async (Defeitos)=> {
        if(Defeitos){
            if (Array.isArray(Defeitos)) {
                Defeitos.forEach(_setName);
            } else {
                _setName(Defeitos);
            }         
        }
        async function _setName(os) {
            os.name = 'OK';                               
        }    
    });        
    this.before('DELETE', "OrdemServicos", async (OrdemServicos)=> {
        if(OrdemServicos){
            const tx = cds.tx(req);
            await tx.run(DELETE.from('Historicos').where({ordemServico_ID:OrdemServicos.ID}));
            await tx.commit();                            
        } 
    });    
    this.after ('READ', "OrdemServicos", async (OrdemServicos)=> {
        if(OrdemServicos){
            if (Array.isArray(OrdemServicos)) {
                OrdemServicos.forEach(_setURLStatus);
            } else {
                _setURLStatus(OrdemServicos);
            }         
        }
        async function _setURLStatus(os) {
            var date1 = new Date();
            var date2 = new Date();            
            os.url = '#fe-lrop-v4&/OrdemServicos(ID='+ os.ID +',IsActiveEntity=true)';   
            if (os.clienteInterno == 'INFRA NET'){
                if (os.dataRecebimento) {     
                    date1 = new Date(os.dataRecebimento);                    
                    if ( os.nfRetornoEmissao) {
                        date2 = new Date(os.nfRetornoEmissao);    
                    } else {
                        date2 = new Date(); 
                    }                                    
                    difference_in_time = date2.getTime() - date1.getTime();  
                    difference_in_days = difference_in_time / (1000 * 3600 * 24);  
                    os.qtdDiasReparador = parseInt(difference_in_days.toFixed(0));
                }   
            }else{
                if (os.dataRecebimento) {
                    date1 = new Date(os.dataRecebimento);    
                    if ( os.dataEntregaCD) {
                        date2 = new Date(os.dataEntregaCD);    
                    } else {
                        date2 = new Date(); 
                    }                                      
                    difference_in_time = date2.getTime() - date1.getTime();  
                    difference_in_days = difference_in_time / (1000 * 3600 * 24);  
                    os.qtdDiasReparador = parseInt(difference_in_days.toFixed(0));
                }   
            }                                                              
        }       
    });
    this.before("UPDATE", "OrdemServicos", async (req) => {
        var date1 = new Date();
        var date2 = new Date();
        let ordemServico = req.data;
        if (ordemServico) {
            if (ordemServico.statusFaturamento_ID == 'Sim') {
                if (!ordemServico.numeroPedido) {
                    req.error ({
                    code: 400,
                    message: 'Obrigatório informar o número do Pedido',
                    target: 'numeroPedido'
                    });
                    return;                    
                }
            }            
        }        
        let os_tmp = await cds.run(SELECT.one.from('OrdemServicos')
                                            .columns(['clienteInterno','dataRecebimento', 'nfSaidaEmissao', 'nfSaidaExpedicao'])
                                            .where({'ID':ordemServico.ID}));          
        if (os_tmp.nfSaidaEmissao && os_tmp.nfSaidaExpedicao) {
            date1 = new Date(os_tmp.nfSaidaEmissao);
            date2 = new Date(os_tmp.nfSaidaExpedicao);
            difference_in_time = date2.getTime() - date1.getTime();  
            difference_in_days = difference_in_time / (1000 * 3600 * 24);  
            req.query.UPDATE.data.qtdDiasExpedicao = difference_in_days;
        }        
        if (ordemServico.dataRecebimento && os_tmp.nfSaidaExpedicao) {
            date1 = new Date(os_tmp.nfSaidaExpedicao);
            date2 = new Date(ordemServico.dataRecebimento);
            difference_in_time = date2.getTime() - date1.getTime();  
            difference_in_days = difference_in_time / (1000 * 3600 * 24);  
            req.query.UPDATE.data.qtdDiasTransporte = difference_in_days;
        }  
        if (ordemServico.clienteInterno == 'INFRA NET'){
            if (ordemServico.dataRecebimento && ordemServico.nfRetornoEmissao ){ 
                date1 = new Date(ordemServico.dataRecebimento);
                date2 = new Date(ordemServico.nfRetornoEmissao);
                difference_in_time = date2.getTime() - date1.getTime();  
                difference_in_days = difference_in_time / (1000 * 3600 * 24);  
                req.query.UPDATE.data.qtdDiasReparador = difference_in_days;            
            }
        }
        else{
            if (ordemServico.dataRecebimento && ordemServico.dataEntregaCD ){ 
                date1 = new Date(ordemServico.dataRecebimento);
                date2 = new Date(ordemServico.dataEntregaCD);
                difference_in_time = date2.getTime() - date1.getTime();  
                difference_in_days = difference_in_time / (1000 * 3600 * 24);  
                req.query.UPDATE.data.qtdDiasReparador = difference_in_days;            
            }
        }      
        if (!ordemServico.statusReparo_ID){
            req.query.UPDATE.data.statusOS = 'Aberto';
        }else{
            if ( ordemServico.statusReparo_ID == 'Aguardando Autorização' || 
                 ordemServico.statusReparo_ID == 'Em Reparo' ||
                 ordemServico.statusReparo_ID == 'Pendente de Reparo - Aguardando Chegada de Componente' ||
                 ordemServico.statusReparo_ID == 'Pendente de Reparo - Aguardando Orçamento' ||
                 ordemServico.statusReparo_ID == 'Equipamento Não Recebido Fisicamente - Verificando com Transporte' ||
                 ordemServico.statusReparo_ID == 'Equipamento Não Recebido Fisicamente - Verificando com Operador Logistico' ){
                req.query.UPDATE.data.statusOS = 'Aberto';
            }
            else{
                ordemServico.statusOS = 'Aberto';
                let os_tmp = await cds.run(SELECT.one.from('OrdemServicos')
                                                .columns('clienteInterno')
                                                .where({'ID':ordemServico.ID})); 
                if ( os_tmp ){                        
                    if (os_tmp.clienteInterno == 'INFRA NET'){
                        if (ordemServico.nfRetorno && ordemServico.nfRetornoEmissao && ordemServico.statusAuditoria_ID == 'Aprovado') {
                            req.query.UPDATE.data.statusOS = 'Encerrado';       
                        }
                    }else{
                        if (os_tmp.clienteInterno == 'CLARO MOVEL'){
                            if (ordemServico.nfRetorno && ordemServico.nfRetornoEmissao && ordemServico.dataEntregaCD) {
                                req.query.UPDATE.data.statusOS = 'Encerrado';       
                            }                                
                        }
                    }      
                }                  
            }
        }                            
        let dt = new Date().toISOString().slice(0, 10); 
        dt = dt + ' ' +new Date().toISOString().slice(11, 19); 
        let os = [];
        if(ordemServico){             
            os.push({    
                'usuario'           : req.user.id,  
                'data'              : dt,
                'status'            : ordemServico.statusOS,
                'descricao'         : 'Alteração da Ordem de Serviço',
                'ordemServico_ID'   : ordemServico.ID
            });   
            const tx = cds.tx(req);
            await tx.run(INSERT.into ('CatalogService.Historicos').rows(os));                            
            os = os[0];
        }
        console.log(os)
    });    
    this.on("READ", "NotasFiscais", async (req) => {        
        // console.log(req); 
        var query = {};   
        let queryParams = parseQueryParams(req.query.SELECT.where);
        // dates for filter
        let prior = new Date().setDate( new Date().getDate() - numberOfDaysToSubstract );        
        let dt_inicial = new Date(prior).toISOString().slice(0, 10); 
        let dt_final = new Date().toISOString().slice(0, 10); 
        // read filters parameters
        if(queryParams.length > 0){
            let dtEmissao = queryParams.filter(x=> x.parametro === 'nfSaidaEmissao');
            if (dtEmissao && dtEmissao.length > 0){
                if (dtEmissao.length > 1){
                    query.dt_inicial = dtEmissao[0].valor;
                    query.dt_final   = dtEmissao[1].valor;
                }else{
                    query.dt_inicial = dtEmissao[0].valor;
                    query.dt_final   = dtEmissao[0].valor;
                }
            }
        }else{
            // Verificar se está fazendo leitura de um registro
            if (req.query.SELECT.from.ref[0].where &&
                req.query.SELECT.from.ref[0].where[0].ref[0] === 'ID'){ 
                let result = await cds.run(req.query);
                return result;
            }else{
                let param = {};
                param.ref = ['nfSaidaEmissao']; 
                req.query.SELECT.where = [];
                req.query.SELECT.where.push(param);
                req.query.SELECT.where.push('>=');
                param = {};
                param.val = dt_inicial;
                req.query.SELECT.where.push(param);
                req.query.SELECT.where.push('and');
                param = {};
                param.ref = ['nfSaidaEmissao']; 
                req.query.SELECT.where.push(param);
                req.query.SELECT.where.push('<=');
                param = {};
                param.val = dt_final;
                req.query.SELECT.where.push(param);
            }
        }        
        if (!query.dt_inicial){        
            query.dt_inicial = dt_inicial;
        }
        if (!query.dt_final){            
            query.dt_final = dt_final;
        }        
        // validate the dates
        let date1 = new Date(query.dt_inicial);
        let date2 = new Date(query.dt_final);
        // to calculate the time difference of two dates
        let difference_in_time = date2.getTime() - date1.getTime();  
        // to calculate the no. of days between two dates
        let difference_in_days = difference_in_time / (1000 * 3600 * 24);
        if (difference_in_days > 30){
            throw new Error('A diferença entre as datas não pode ser maior que 30 dias');
        }
        //Ler parametros de pesquisar do SAP
        let result = await cds.run(SELECT.from('FiltrosPesquisa')
                                        .columns('ID','empresa','cod_operacao'));        
        query.parametros = [];
        if (Array.isArray(result)) {
            result.forEach(_lerFiltro);
        } else {
            _lerFiltro(result);
        }           
        //Ler fornecedor associado ao usuário 
        result = await cds.run(SELECT.from('Usuarios')
                                        .columns('email','fornecedor','cnpj')
                                        .where({'email':req.user.id } ) );         
        if(result[0]){
            query.fornecedor = result[0].fornecedor;
            query.cnpj       = result[0].cnpj;
        }
        // Buscar Notas Fiscais no SAP através do CPI
        //let url = 'https://claro-dev.it-cpi001-rt.cfapps.eu10.hana.ondemand.com/http/notasfiscais';
        let url = 'https://claro-prd.it-cpi008-rt.cfapps.br10.hana.ondemand.com/http/notasfiscais';
        var ordemServico = [];

        const data = 'grant_type=client_credentials&client_id=sb-841ee75f-f9c3-4b73-a6e7-e4366ffdb56e!b396|it-rt-claro-prd!b106&'+
            'client_secret=63dd7b91-cd1e-404d-8336-b4cc7fb50c79$RkOLj3GOxNSgl7xtRVgFHV2OcBo80tutDiLsHhCFYe8=';
            
        var user_token = '';
        var token_url = 'https://claro-prd.authentication.br10.hana.ondemand.com/oauth/token';
        await axios.post(token_url, data)   
        .then(response => {
            //console.log(response.data);
            user_token = response.data.access_token;
            //console.log('userresponse ' + response.data.access_token); 
            })   
        .catch((error) => {
            console.log('error ' + error);   
        });

        const AuthStr = 'Bearer '.concat(user_token); 

        await axios.post(url, query,
            { 
               headers: {
                    'Content-Type': 'application/json;charset=utf-8',
                    'Accept': '*//*',
                    'Connection': 'keep-alive'
                    ,
                    'Authorization': AuthStr
                }                     
            }).then(function (response) {
                var json = {};
                if (response.status < 200 && response.status > 299) {
                    //throw new Error('Erro na pesquisa de Notas Fiscais');
                } else {
                    json = parseResponse(response);
                }
                return json;
            });   
        if(ordemServico.length > 0){                  
            const tx = cds.tx(req);
            await tx.run(INSERT.into ('CatalogService.OrdemServicos').rows(ordemServico));
            await tx.commit();     
        }        
        return await cds.run(req.query);                              
        async function parseResponse(response) {
            Number.prototype.lpad = function(padString, length) {
                let str = this.toString();
                while (str.length < length)
                    str = padString + str;
                return str;
            }               
            let obj = [];
            if (response.data.T_RETORNO.item){    
                let max = await cds.run(SELECT.one.from('OrdemServicos').columns('max(sequencial) as ID'));
                var max_os_id = max.ID;                                 
                for (let i=0; i<response.data.T_RETORNO.item.length; i++){
                    let item = response.data.T_RETORNO.item[i];
                    let os = await cds.run(SELECT.one.from('OrdemServicos')
                                                    .where({'remessa':item.DOCUMENTO_REM},
                                                           {'nfSaida':item.N_REMESSA_REM},
                                                           {'cdOrigem':item.COD_ESTAB_REM})); 
                    if ( !os ){         
                        let areaClientes = await cds.run(SELECT.one.from('CentroAreaCliente')
                                                            .columns(['estado','areaCliente'])
                                                            .where({'ID':item.COD_ESTAB_REM}));  
                        if(!areaClientes){
                            areaClientes = [];
                            areaClientes.push({    
                                'ID'      : item.COD_ESTAB_REM,
                                'cd'          : '',
                                'estado'      : '',
                                'areaCliente' : ''                                                                       
                            });   
                            const tx = cds.tx(req);
                            await tx.run(INSERT.into ('CatalogService.CentroAreaCliente').rows(areaClientes));    
                            await tx.commit();                             
                            areaClientes = [];
                            areaClientes.ID = item.COD_ESTAB_REM;
                            areaClientes.cd = '';
                            areaClientes.estado = '';
                            areaClientes.areaCliente = '';
                        }    
                        let notaFiscal = await cds.run(SELECT.one.from('NotasFiscais')
                                                         .columns(['ID','nfSaida', 'cdOrigem'])
                                                         .where({'nfSaida':item.N_REMESSA_REM},
                                                               {'cdOrigem':item.COD_ESTAB_REM}));  
                        if(!notaFiscal || notaFiscal.length == 0){  
                            notaFiscal = [];
                            notaFiscal.push({    
                                'ufOrigem'        : areaClientes.estado,  
                                'cdOrigem'        : item.COD_ESTAB_REM,
                                'clienteInterno'  : areaClientes.areaCliente,
                                'nfSaida'         : item.N_REMESSA_REM,
                                'nfSaidaEmissao'  : item.BLDAT_REM 
                            });   
                            const tx = cds.tx(req);
                            await tx.run(INSERT.into ('CatalogService.NotasFiscais').rows(notaFiscal));            
                            await tx.commit();                
                            notaFiscal = notaFiscal[0];
                        }
                        if(!item.MATNR_REM){ item.MATNR_REM = ''; }
                        let mat_number  = item.MATNR_REM.replace(/^0+/, '');                             
                        let material = await cds.run(SELECT.one.from('MaterialConfig')
                                                            .columns(['tecnologia','modelo','fabricante','partNumber'])
                                                            .where({'codigo':mat_number})); 
                        if(!material){
                            material = [];
                            material.tecnologia = '';
                            material.modelo     = '';
                            material.fabricante = '';
                            material.partNumber = '';
                        }    
                        let qtd = item.MENGE_INIC_REM;
                        if (!qtd) {
                            qtd = 1;
                        } 
                        for (let index = 0; index < qtd; index++) {
                            max_os_id = max_os_id + 1;
                            os = item.NAME_REM.substring(0,3) +
                                    item.COD_ESTAB_REM +
                                    max_os_id.lpad('0', 9); 
                            ordemServico.push({    
                                'numero'          : os,     
                                'sequencial'      : max_os_id,
                                'material'        : mat_number,
                                'materialDesc'    : item.MAKTX_REM,
                                'materialTipo'    : material.tecnologia,
                                'materialTecn'    : material.modelo,
                                'materialFabr'    : material.fabricante,
                                'materialPart'    : material.partNumber,
                                'equipamento'     : item.EQUNR,
                                'serial'          : item.SERGE,
                                'nomeReparadora'  : item.NAME_REM,  
                                'ufOrigem'        : areaClientes.estado,  
                                'cdOrigem'        : item.COD_ESTAB_REM,
                                'clienteInterno'  : areaClientes.areaCliente,
                                'nfSaida'         : item.N_REMESSA_REM,
                                'nfSaidaEmissao'  : item.BLDAT_REM,
                                'remessa'         : item.DOCUMENTO_REM,
                                'statusOS'        : 'Aberto',
                                'nf_ID'           : notaFiscal.ID                                                                          
                            });                              
                        }                                                                                     
                    }
                };
            }
            //else{
                //throw new Error(req.query.SELECT.where);
                //console.log('Não retornou nenhuma nota fiscal');
            //}
            return obj;
        }                 
        function _lerFiltro(filtro) {
            let parametro = {};
            if (filtro.empresa) {                    
                parametro.empresa  = filtro.empresa;                 
                parametro.operacao = filtro.cod_operacao;
            }
            query.parametros.push(parametro);         
        }       
        function parseQueryParams(expr) {
            if (!expr) {
                return {};
            }
            let obj = [];            
            for (let i=0; i<expr.length; ){
                let param = {};
                if (!expr[i].ref){ i = 10}
                param.parametro = expr[i].ref[0]; 
                param.operador  = expr[i+1];
                param.valor     = expr[i+2].val;
                i = i + 3;
                if(expr.length > i){
                    param.sufixo = expr[i];
                    i++;
                }
                obj.push(param);
            }
            return obj;        
        } 
    });
    this.on('READ','CurrentUser', req => {
        if(req.req.authInfo){
            return {
                id:         req.user.id,
                firstName:  req.req.authInfo.getGivenName(),
                lastName:   req.req.authInfo.getFamilyName(),
                email:      req.req.authInfo.getEmail()
            }
        }else{
            return {
               id:         req.user.id,
            }
        }
    })
});  
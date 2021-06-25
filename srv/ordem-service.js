const cds = require("@sap/cds");

module.exports = cds.service.impl(function () {       
    const {FiltrosPesquisa}      = cds.entities('com.portal.FiltrosPesquisa');  
    const {MaterialConfig}       = cds.entities('com.portal.MaterialConfig');  
    const {CentroAreaCliente}    = cds.entities('com.portal.CentroAreaCliente');  
    const {Defeitos}             = cds.entities('com.portal.Defeitos');  
    this.after ('READ', "OrdemServicos", async (OrdemServicos)=> {
        if(OrdemServicos){
            if (Array.isArray(OrdemServicos)) {
                OrdemServicos.forEach(_setQtdDiasPosseForncedor);
            } else {
                _setQtdDiasPosseForncedor(OrdemServicos);
            }         
        }
        async function _setQtdDiasPosseForncedor(os) {
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
    this.before('NEW','Defeitos', async(req)=>{ 
        let filtro = req.data;
        let filtro_tmp = await cds.run(SELECT.one.from('Defeitos')
                                            .columns(['ID'])
                                            .where({'ID':filtro.ID}));      
        if (filtro_tmp && filtro_tmp.ID) {
            req.error ({
                code: 400,
                message: 'Id já existe.',
                target: 'ID'
            });      
        }                                      
    });     
    this.before('NEW','Usuarios', async(req)=>{ 
        let filtro = req.data;
        let filtro_tmp = await cds.run(SELECT.one.from('Usuarios')
                                            .columns(['ID'])
                                            .where({'ID':filtro.ID}));      
        if (filtro_tmp && filtro_tmp.ID) {
            req.error ({
                code: 400,
                message: 'Id já existe.',
                target: 'ID'
            });      
        }                                      
    });         
    this.before('NEW','MaterialConfig', async(req)=>{ 
        let filtro = req.data;
        let filtro_tmp = await cds.run(SELECT.one.from('MaterialConfig')
                                            .columns(['ID'])
                                            .where({'ID':filtro.ID}));      
        if (filtro_tmp && filtro_tmp.ID) {
            req.error ({
                code: 400,
                message: 'Id já existe.',
                target: 'ID'
            });      
        }                                      
    });    
    this.before('NEW','CentroAreaCliente', async(req)=>{ 
        let filtro = req.data;
        let filtro_tmp = await cds.run(SELECT.one.from('CentroAreaCliente')
                                            .columns(['ID'])
                                            .where({'ID':filtro.ID}));      
        if (filtro_tmp && filtro_tmp.ID) {
            req.error ({
                code: 400,
                message: 'Id já existe.',
                target: 'ID'
            });      
        }                                      
    });    
    this.before('NEW','FiltrosPesquisa', async(req)=>{ 
        let filtro = req.data;
        let filtro_tmp = await cds.run(SELECT.one.from('FiltrosPesquisa')
                                            .columns(['ID'])
                                            .where({'ID':filtro.ID}));      
        if (filtro_tmp && filtro_tmp.ID) {
            req.error ({
                code: 400,
                message: 'Id já existe.',
                target: 'ID'
            });      
        }                                      
    });
    this.before('UPDATE', 'OrdemServicos', async (req) => {
        let ordemServico = req.data;
        var date1 = new Date();
        var date2 = new Date();         
        let os_tmp = await cds.run(SELECT.one.from('OrdemServicos')
                                            .columns(['clienteInterno','nfSaidaEmissao','dataRecebimento',
                                                      'dataEntregaCD','nfRetornoExpedicao', 'statusOS'])
                                            .where({'ID':ordemServico.ID}));          
        if (os_tmp.nfSaidaEmissao && ordemServico.nfSaidaExpedicao) {
            date1 = new Date(os_tmp.nfSaidaEmissao);
            date2 = new Date(ordemServico.nfSaidaExpedicao);
            difference_in_time = date2.getTime() - date1.getTime();  
            difference_in_days = difference_in_time / (1000 * 3600 * 24);  
            req.query.UPDATE.data.qtdDiasExpedicao = difference_in_days;
        }        
        if (os_tmp.dataRecebimento && ordemServico.nfSaidaExpedicao) {
            date1 = new Date(ordemServico.nfSaidaExpedicao);
            date2 = new Date(os_tmp.dataRecebimento);
            difference_in_time = date2.getTime() - date1.getTime();  
            difference_in_days = difference_in_time / (1000 * 3600 * 24);  
            req.query.UPDATE.data.qtdDiasTransporte = difference_in_days;
        }  
        if (ordemServico.clienteInterno == 'INFRA NET'){
            if (os_tmp.dataRecebimento) {
                date1 = new Date(os_tmp.dataRecebimento);
                if (os_tmp.nfRetornoEmissao) {
                    date2 = new Date(os_tmp.nfRetornoEmissao);
                }else{
                    date2 = new Date();   
                }         
                difference_in_time = date2.getTime() - date1.getTime();  
                difference_in_days = difference_in_time / (1000 * 3600 * 24);  
                req.query.UPDATE.data.qtdDiasReparador = difference_in_days;
            }               
        }
        else{
            if (os_tmp.dataRecebimento) {
                date1 = new Date(os_tmp.dataRecebimento);
                if (os_tmp.dataEntregaCD) {
                    date2 = new Date(os_tmp.dataEntregaCD);
                }else{
                    date2 = new Date();   
                }         
                difference_in_time = date2.getTime() - date1.getTime();  
                difference_in_days = difference_in_time / (1000 * 3600 * 24);  
                req.query.UPDATE.data.qtdDiasReparador = difference_in_days;
            }
        }                                          
        let dt = new Date().toISOString().slice(0, 10); 
        dt = dt + ' ' +new Date().toISOString().slice(11, 19); 
        let os = [];
        if(ordemServico){             
            os.push({    
                'usuario'           : req.user.id,  
                'data'              : dt,
                'status'            : os_tmp.statusOS,
                'descricao'         : 'Adminstrativo - Alteração',
                'ordemServico_ID'   : ordemServico.ID
            });   
            await cds.tx(req).run(INSERT.into ('Historicos').rows(os));                            
        }
    });        
});
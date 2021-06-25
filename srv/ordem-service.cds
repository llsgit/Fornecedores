using com.portal as portal from '../db/data-model';

service OrdemService @( 
        path:'/ordem',
        requires: ['Admin']
    ){
    entity CentroAreaCliente            as projection on portal.CentroAreaCliente;    
    entity OrdemServicos                as projection on portal.OrdemServicos;
    entity MaterialConfig               as projection on portal.MaterialConfig;
    entity Usuarios                     as projection on portal.Usuarios;
    entity Defeitos                     as projection on portal.Defeitos;
    entity Reparos            @readonly as projection on portal.Reparos;
    entity FiltrosPesquisa              as projection on portal.FiltrosPesquisa;
    entity Historicos         @readonly as projection on portal.Historicos; 
    entity StatusBoolean      @readonly as projection on portal.StatusBoolean;     
    annotate  OrdemService.OrdemServicos with {
        numero              @title: 'Número da Ordem de Serviço'    @Common.FieldControl: #ReadOnly;
        clienteInterno      @title: 'Cliente Interno'   @Common.FieldControl: #ReadOnly;
        cdOrigem            @title: 'CD de Origem'      @Common.FieldControl: #ReadOnly;
        ufOrigem            @title: 'Estado de Origem'  @Common.FieldControl: #ReadOnly;
        nfSaidaEmissao      @title: 'Data de Emissão'   @Common.FieldControl: #ReadOnly;
        nfSaida             @title: 'Nota Fiscal Saída' @Common.FieldControl: #ReadOnly;
        nfSaidaExpedicao    @title: 'Data de Expedição' ;        
        dataRecebimento     @title: 'Data de Recebimento no Fornecedor' @Common.FieldControl: #ReadOnly;  
        nfRetorno           @title: 'Nº NF de retorno'  @Common.FieldControl: #ReadOnly;  
        nfRetornoEmissao    @title: 'Data Emissão NF de Retorno' @Common.FieldControl: #ReadOnly;  
        nfRetornoExpedicao  @title: 'Data de Expedição ou Data de Coleta' @Common.FieldControl: #ReadOnly;  
        dataEntregaCD       @title: 'Data de Entrega no CD Origem';  
        material            @title: 'Material'          @Common.FieldControl: #ReadOnly;
        materialDesc        @title: 'Descrição'         @Common.FieldControl: #ReadOnly;
        materialTipo        @title: 'Tipo'              @Common.FieldControl: #ReadOnly;
        materialTecn        @title: 'Tecnologia'        @Common.FieldControl: #ReadOnly;
        materialFabr        @title: 'Fabricante'        @Common.FieldControl: #ReadOnly;
        materialPart        @title: 'Part Number'       @Common.FieldControl: #ReadOnly;
        equipamento         @title: 'Equipamento'       @Common.FieldControl: #ReadOnly;
        serial              @title: 'Serial'            @Common.FieldControl: #ReadOnly;
        nomeReparadora      @title: 'Nome da Reparadora'@Common.FieldControl: #ReadOnly;
        defeito_ID          @title: 'Defeito'           @Common.FieldControl: #ReadOnly;
        garantia_ID         @title: 'Garantia'          @Common.FieldControl: #ReadOnly;
        statusReparo_ID     @title: 'Já foi Reparado'   @Common.FieldControl: #ReadOnly;
        statusAuditoria_ID  @title: 'Status Auditoria'  @Common.FieldControl: #ReadOnly;
        valorTotal          @title: 'Valor total do reparo'  @Common.FieldControl: #ReadOnly;
        statusFaturamento_ID@title: 'Já foi faturado'   @Common.FieldControl: #ReadOnly; 
        numeroPedido        @title: 'Número do Pedido'  @Common.FieldControl: #ReadOnly; 
        observacao          @title: 'Observação'        @UI.MultiLineText @Common.FieldControl: #ReadOnly;
        statusOS            @title: 'Status da Ordem de Serviço' @Common.FieldControl: #ReadOnly;
        qtdDiasExpedicao    @title: 'Quantidade de dias para a Expedição Transporte' @Common.FieldControl: #ReadOnly;
        qtdDiasTransporte   @title: 'Quantidade de dias em Transporte' @Common.FieldControl: #ReadOnly;
        qtdDiasReparador    @title: 'Quantidade de dias do equipamento em posse do reparador' @Common.FieldControl: #ReadOnly;     
        Fabricante          @title: 'Fabricante'  @Common.FieldControl: #ReadOnly;
        ID                  @UI.Hidden:true;
        nf_ID               @UI.Hidden:true;
        remessa             @UI.Hidden:true;
        sequencial          @UI.Hidden:true;
        url                 @UI.Hidden:true;
    } ;

    annotate  OrdemService.CentroAreaCliente with @( 
        odata.draft.enabled,
        Capabilities : [ { DeleteRestrictions : {Deletable : false},
                            SearchRestrictions : {Searchable: false} } ],                     
        Common       : { Label : 'Centro x Area x Cliente'} ,
        UI: {
            SelectionFields : [  ID, cd, estado, areaCliente ],   
            LineItem: [
                { Value: ID},
                { Value: cd},
                { Value: estado},
                { Value: areaCliente}
            ]
        }
    );    


    annotate  OrdemService.MaterialConfig with @( 
        odata.draft.enabled,
        Capabilities : [ { DeleteRestrictions : {Deletable : false},
                            SearchRestrictions : {Searchable: false} } ],                     
        Common       : { Label : 'Materiais'} ,
        UI: {
            SelectionFields : [  codigo, tecnologia, modelo, fabricante ],   
            LineItem: [
                { Value: codigo},
                { Value: tecnologia},
                { Value: modelo},
                { Value: fabricante},
                { Value: partNumber}
            ]
        }
    );    

    annotate OrdemService.Historicos with @( 
        //Common       : { Label : 'Ordem de Servico'} ,
        UI: {
            LineItem: [
                { Value: usuario,      Label: 'Usuário'},
                { Value: data,  Label: 'Data'},
                { Value: status,  Label: 'Status'},
                { Value: descricao,  Label: 'Descrição'}
            ]
        }
    );    

    annotate OrdemService.Reparos with @(
        Common: { Label : 'Lista de Reparos'} ,
        Common.SemanticKey: [ID],
        Identification: [{Value:ID}],
        UI: {
            SelectionFields: [ ID ],
            LineItem:[
                {Value: ID,  Label: 'Status de Reparo'}            
            ]
        }
    );    

    annotate OrdemService.Reparos with {
        ID       @title: 'Status de Reparo';
        name     @title: 'Status de Reparo';
    };
    
    annotate OrdemService.Defeitos with @(
        Common: { Label : 'Lista de Defeitos'} ,
        Common.SemanticKey: [ID],
        Identification: [{Value:ID}],
        UI: {
            SelectionFields: [ ID, name ],
            LineItem:[
                {Value: name},
                {Value: ID},
            ]
        }
    );

    annotate OrdemService.Defeitos with {
        name         @title: 'Área Cliente';
        ID           @title: 'Defeito'
    };

    annotate CatalogService.statusAuditoria with {
        ID           @title: 'Status da Auditoria';
        name         @title: 'Descrição'
    };    

    annotate OrdemService.statusAuditoria with @( 
        Common       : { Label : 'Status da Auditoria'} ,
        UI: {
            LineItem: [
                { Value: ID, Label: 'Opção' },
                { Value: name, Label: 'Descrição' }
            ]
        }
    );    
    annotate OrdemService.StatusBoolean with @( 
        Common       : { Label : 'Lista de Opções'} ,
        UI: {
            LineItem: [
                { Value: ID, Label: 'Opção' },
                { Value: name, Label: 'Descrição' }
            ]
        }
    );            
    annotate  OrdemService.FiltrosPesquisa with @( 
        odata.draft.enabled,
        Capabilities : [ { DeleteRestrictions : {Deletable : false},
                            SearchRestrictions : {Searchable: false} } ],                     
        Common       : { Label : 'Filtro de Pesquisa'} ,
        UI: {
            SelectionFields : [  empresa, cod_operacao ],   
            LineItem: [
                { Value: ID},
                { Value: empresa},
                { Value: cod_operacao}
            ]        
        }        
    );
    annotate OrdemService.FiltrosPesquisa with {
        ID       @title: 'ID';
    };    

}
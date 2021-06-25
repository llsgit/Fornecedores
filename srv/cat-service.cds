using com.portal as portal from '../db/data-model';

service CatalogService @(requires: ['Admin', 'Reparador']){
    entity CentroAreaCliente  @readonly as projection on portal.CentroAreaCliente;
    entity MaterialConfig     @readonly as projection on portal.MaterialConfig;
    entity Usuarios           @readonly as projection on portal.Usuarios;
    entity Defeitos           @readonly as projection on portal.Defeitos;
    entity Reparos            @readonly as projection on portal.Reparos;
    entity FiltrosPesquisa    @readonly as projection on portal.FiltrosPesquisa;
    entity OrdemServicos                as projection on portal.OrdemServicos;
    entity Historicos         @readonly as projection on portal.Historicos; 
    entity StatusBoolean      @readonly as projection on portal.StatusBoolean; 
    entity NotasFiscais       @readonly as projection on portal.NotasFiscais;   
    entity CurrentUser{
    key id        : String(50);
        firstName : String(50);
        lastName  : String(50);
        email     : String(50);
    };

    annotate CatalogService.NotasFiscais with{
            clienteInterno      @title: 'Cliente Interno';    
            statusOS            @title: 'Status da OS';
            statusReparo1       @title: 'Status do Reparo';
            cdOrigem            @title: 'CD de Origem';
            ufOrigem            @title: 'Estado de Origem';
            nfSaidaEmissao      @title: 'Data de Emissão';
            nfSaidaExpedicao    @title: 'Data de Expedição';
            dataRecebimento     @title: 'Data de Recebimento no Fornecedor';        
    } ;
    
    annotate  CatalogService.OrdemServicos with {
        numero              @title: 'Número da Ordem de Serviço'    @Common.FieldControl: #ReadOnly;
        clienteInterno      @title: 'Cliente Interno'   @Common.FieldControl: #ReadOnly;
        cdOrigem            @title: 'CD de Origem'      @Common.FieldControl: #ReadOnly;
        ufOrigem            @title: 'Estado de Origem'  @Common.FieldControl: #ReadOnly;
        nfSaidaEmissao                                  @Common.FieldControl: #ReadOnly;
        nfSaida                                         @Common.FieldControl: #ReadOnly;
        nfSaidaExpedicao    @title: 'Data de Expedição' @Common.FieldControl: #ReadOnly;
        dataRecebimento     @title: 'Data do recebimento no fornecedor';
        nfRetorno           @title: 'Nº NF de retorno';
        nfRetornoEmissao    @title: 'Data Emissão NF de Retorno';
        nfRetornoExpedicao  @title: 'Data de Expedição ou Data de Coleta';
        dataEntregaCD       @title: 'Data de Entrega no CD Origem' ;
        material            @title: 'Material'          @Common.FieldControl: #ReadOnly;
        materialDesc        @title: 'Descrição'         @Common.FieldControl: #ReadOnly;
        materialTipo        @title: 'Tipo'              @Common.FieldControl: #ReadOnly;
        materialTecn        @title: 'Tecnologia'        @Common.FieldControl: #ReadOnly;
        materialFabr        @title: 'Fabricante'        @Common.FieldControl: #ReadOnly;
        materialPart        @title: 'Part Number'       @Common.FieldControl: #ReadOnly;
        nomeReparadora      @title: 'Nome da Reparadora'@Common.FieldControl: #ReadOnly;
        equipamento         @title: 'Equipamento';
        serial              @title: 'Serial';        
        qtdDiasExpedicao    @title: 'Quantidade de dias para a Expedição Transporte' @Common.FieldControl: #ReadOnly;
        qtdDiasTransporte   @title: 'Quantidade de dias em Transporte' @Common.FieldControl: #ReadOnly;
        qtdDiasReparador    @title: 'Quantidade de dias do equipamento em posse do reparador' @Common.FieldControl: #ReadOnly;
        defeito_ID          @title: 'Defeito';
        garantia_ID         @title: 'Garantia';
        statusReparo_ID     @title: 'Já foi Reparado';
        statusAuditoria_ID  @title: 'Status Auditoria';
        statusFaturamento_ID@title: 'Já foi faturado';
        observacao          @title: 'Observação'        @UI.MultiLineText;
        statusOS            @title: 'Status da Ordem de Serviço' @Common.FieldControl: #ReadOnly;
    } ;
    annotate CatalogService.Historicos with @( 
        //Common       : { Label : 'Ordem de Servico'} ,
        UI: {
            LineItem: [
                { Value: usuario,      Label: 'Usuário'},
                { Value: data,  Label: 'Data'},
                { Value: status,  Label: 'Status'},
                { Value: descricao,  Label: 'Descrição'}
            ],
            PresentationVariant : {
                SortOrder : [
                    {
                        $Type : 'Common.SortOrderType',
                        Property : data,
                        Descending : true,
                    },
                ],
                Visualizations : ['@UI.LineItem']
            }            
        }
    );    

    annotate CatalogService.Reparos with @(
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
    annotate CatalogService.Reparos with {
        ID       @title: 'Status de Reparo';
    };    
    annotate CatalogService.Defeitos with @(
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
    annotate CatalogService.Defeitos with {
        name         @title: 'Área Cliente';
        ID           @title: 'Defeito'
    };

    annotate CatalogService.statusAuditoria with {
        ID           @title: 'Opção';
        name         @title: 'Descrição'
    };    

    annotate CatalogService.statusAuditoria with @( 
        Common       : { Label : 'Status da Auditoria'} ,
        UI: {
            LineItem: [
                { Value: ID, Label: 'Opção' },
                { Value: name, Label: 'Descrição' }
            ]
        }
    );    
    annotate CatalogService.StatusBoolean with @( 
        Common       : { Label : 'Lista de Opções'} ,
        UI: {
            LineItem: [
                { Value: ID, Label: 'Opção' },
                { Value: name, Label: 'Descrição' }
            ]
        }
    );            
}
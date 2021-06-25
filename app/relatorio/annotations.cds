using OrdemService as service from '../../srv/ordem-service';

extend OrdemService.OrdemServicos with @( 
    //fiori.draft.enabled,
    odata.draft.enabled,
    Capabilities : { Deletable : false, Insertable : false },
    Common       : { Label : 'Ordem de Servico'} ,
    UI: {        
        SelectionFields : [  ufOrigem, cdOrigem, nfSaidaEmissao ],    
        LineItem: [
            { Value: numero,                Label: 'Ordem de Serviço'},     
            { Value: clienteInterno,        Label: 'Cliente Interno'},
            { Value: cdOrigem,              Label: 'CD Origem'},
            { Value: ufOrigem,              Label: 'Estado'},
            { Value: nfSaida,               Label: 'NF saída Reparo'},
            { Value: nfSaidaEmissao,        Label: 'Data Emissão'},
            { Value: nfSaidaExpedicao,      Label: 'Data de Expedição'},
            { Value: nfRetorno,             Label: 'Nº NF de retorno'},
            { Value: nfRetornoExpedicao,    Label: 'Data de Expedição ou Coleta'},
            { Value: dataRecebimento,       Label: 'Data do recebimento no fornecedor' },
            { Value: dataEntregaCD,         Label: 'Data de Entrega no CD Origem'},                                             
            { Value: material,              Label: 'Material'},
            { Value: materialDesc,          Label: 'Descrição'},
            { Value: materialTipo,          Label: 'Tipo'},
            { Value: materialTecn,          Label: 'Tecnologia'},
            { Value: materialPart,          Label: 'Part Number'},
            { Value: equipamento,           Label: 'Equipamento'},
            { Value: serial,                Label: 'Serial'},
            { Value: qtdDiasExpedicao,      Label: 'Qtd. dias para a Expedição Transporte'},
            { Value: qtdDiasTransporte,     Label: 'Qtd. dias em Transporte'},
            { Value: qtdDiasReparador,      Label: 'Qtd. dias equipamento em posse do reparador'},
            { Value: nomeReparadora,        Label: 'Nome da Reparadora'},
            { Value: garantia_ID,           Label: 'Garantia'},
            { Value: statusReparo_ID,       Label: 'Status do Reparo'},                        
            { Value: defeito_ID,            Label: 'Defeito Encontrado'},
            { Value: statusAuditoria_ID,    Label: 'Status Auditoria'},
            { Value: valorTotal,            Label: 'Valor total do reparo'},
            { Value: statusFaturamento_ID,  Label: 'Status de Faturamento'},
            { Value: numeroPedido,          Label: 'Número do Pedido'},                        
            { Value: observacao,            Label: 'Observação'},
            { Value: statusOS,              Label: 'Status da OS'}                                                
        ],
        HeaderInfo : {
            TypeName       : 'Ordem de Serviço',
            TypeNamePlural : 'Ordens de Serviço',
            TypeImageUrl   : 'sap-icon://document-text',
            Title          : {Label: 'Cliente Interno', Value : clienteInterno },
            Description    : {Label: 'Número da Ordem de Serviço', Value : numero }
        },        
        PresentationVariant : {
            SortOrder : [
                {
                    $Type : 'Common.SortOrderType',
                    Property : numero,
                    Descending : true,
                },
            ],
            Visualizations : ['@UI.LineItem']
        },                         
        Facets: [           
            {
                $Type  : 'UI.CollectionFacet',
                Target : '@UI.FieldGroup#LogisticaData',
                ID     : 'logistica_id',
                Label  : 'Logística',
                Facets : [
                    {
                        $Type  : 'UI.ReferenceFacet',
                        Label  : 'Movimentação e informações referente ao envio do equipamento',
                        ID     : 'logistica_equipamento_id',
                        Target : '@UI.FieldGroup#LogisticaEquipamentoData'
                    },
                    {
                        $Type  : 'UI.ReferenceFacet',
                        Label  : 'Informações referente ao recebimento do Equipamento no fornecedor',
                        ID     : 'logistica_fornecedor_id',
                        Target : '@UI.FieldGroup#LogisticaFornecedorData'
                    }
                ]                    
            },
            {
                $Type  : 'UI.ReferenceFacet',
                Target : '@UI.FieldGroup#MaterialData',
                Label  : 'Material'
            },
            {
                $Type  : 'UI.ReferenceFacet',
                Target : '@UI.FieldGroup#Reparo',
                Label  : 'Reparo'
            },
            {
                $Type: 'UI.ReferenceFacet',
                Label: 'Histórico',
                Target: 'historico/@UI.LineItem' 				
            }                
        ],
        FieldGroup #LogisticaEquipamentoData : {
            Data : [ 
                { Value : nfSaidaExpedicao, Label: 'Data de expedição', },
                { Value : nfSaida , Label: 'NF saída de envio P/ Reparo'},
                { Value : nfSaidaEmissao, Label: 'Data Emissão NF (Envio)'},
                { Value : cdOrigem, Label: 'CD - Origem'},
                { Value : ufOrigem, Label: 'Estado'}
        ]},
        FieldGroup #LogisticaFornecedorData : {
            Data : [ 
                { Value : dataRecebimento },
                { Value : nfRetorno },
                { Value : nfRetornoEmissao },
                { Value : nfRetornoExpedicao },
                { Value : dataEntregaCD }
        ]},            
        FieldGroup #MaterialData : {
            Data : [ 
                { Value : material,     Label: 'Material'},
                { Value : materialDesc, Label: 'Descrição'},
                { Value : materialTipo, Label: 'Tipo'},
                { Value : materialTecn, Label: 'Tecnologia'},
                { Value : materialFabr, Label: 'Fabricante'},
                { Value : materialPart, Label: 'Part Number'},
                { Value : equipamento,  Label: 'Equipamento'},
                { Value : serial,       Label: 'Serial'},
                { Value : qtdDiasExpedicao },
                { Value : qtdDiasTransporte },
                { Value : qtdDiasReparador }  
        ]},            
        FieldGroup #Reparo : {
            Data : [ 
                { Value : nomeReparadora,       Label: 'Nome da Reparadora'},
                { Value : garantia.ID,          Label: 'Garantia'},
                { Value : statusReparo.name,    Label: 'Status do Reparo'},                        
                { Value : defeito.ID,           Label: 'Defeito Encontrado'},
                { Value : statusAuditoria.ID,   Label: 'Status Auditoria'},
                { Value : valorTotal,           Label: 'Valor total do reparo'},
                { Value : statusFaturamento.ID, Label: 'Status de Faturamento'},
                { Value : numeroPedido,         Label: 'Número do Pedido'},                        
                { Value : observacao,           Label: 'Observação'},
                { Value : statusOS,             Label: 'Status da OS'}      
        ]}                                               
    }        
);


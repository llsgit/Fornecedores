using CatalogService as service from '../../srv/cat-service';


extend CatalogService.NotasFiscais with @(
    Common       : {
        Label : 'Notas Fiscais'
    },
    Capabilities : {
        DeleteRestrictions : {Deletable : false},
        SearchRestrictions:  {Searchable: false},
        FilterRestrictions:  {RequiredProperties: [nfSaidaEmissao] }
    },
    UI: {
        SelectionFields : [  ufOrigem, cdOrigem, nfSaidaEmissao ],    
        // Presentation in the List Report
        LineItem: { 
            $value : [
                { Value: clienteInterno, Label: 'Cliente Interno'},
                { Value: cdOrigem, Label: 'CD Origem'},
                { Value: ufOrigem, Label: 'Estado'},
                { Value: nfSaida, Label: 'NF saída Reparo'},
                { Value: nfSaidaEmissao, Label: 'Data Emissão'}
            ] 
        } ,
        HeaderInfo : {
            TypeName       : 'Nota Fiscal',
            TypeNamePlural : 'Notas Fiscais',
            TypeImageUrl   : 'sap-icon://document-text',
            Title          : { Value : clienteInterno, Label: 'Cliente Interno' },
            Description    : { Value : nfSaida, Label: 'Nota Fiscal de Saída' }
        },        
        PresentationVariant : {
            SortOrder : [
                {
                    $Type : 'Common.SortOrderType',
                    Property : nfSaidaEmissao,
                    Descending : false,
                }                           
            ],
            Visualizations : ['@UI.LineItem'],
        },               
        HeaderFacets : [
            {
                $Type  : 'UI.ReferenceFacet',
                Target : '@UI.FieldGroup#GeneralInformation',
                Label  : 'Origem'
            },
            {
                $Type  : 'UI.ReferenceFacet',
                Target : '@UI.FieldGroup#Datas',
                Label  : 'Eventos'
            }          
        ],        
        FieldGroup #GeneralInformation : {
            Data : [
                { Value : cdOrigem },
                { Value : ufOrigem },
            ]
        },
        FieldGroup #Datas : {
            Data : [
                { Value : nfSaidaEmissao }
            ]
        },             
        Facets: [
            {
                $Type: 'UI.ReferenceFacet',
                //Label: 'Ordens de Serviço',
                Target: 'Ordens/@UI.LineItem' 				
            }
        ] 
    }                                  
);
extend CatalogService.OrdemServicos with @( 
    //fiori.draft.enabled,
    odata.draft.enabled,
    Capabilities : [ { DeleteRestrictions : {Deletable : false},
                        SearchRestrictions : {Searchable: false} } ],
    Common       : { Label : 'Ordem de Servico'} ,
    UI: {
        LineItem: [
            { 
                $Type: 'UI.DataFieldWithUrl', 
                Url: url, 
                Value: numero,      Label: 'Ordem de Serviço'
            },                          
            { Value: material,      Label: 'Material'},
            { Value: materialDesc,  Label: 'Descrição'},
            { Value: materialTipo,  Label: 'Tipo'},
            { Value: materialTecn,  Label: 'Tecnologia'},
            { Value: equipamento,   Label: 'Equipamento'},
            { Value: serial,        Label: 'Serial'}                        
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
                { Value : cdOrigem, Label: 'CD de Origem'},
                { Value : ufOrigem, Label: 'Estado de Origem' }
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
                { Value : garantia_ID,          Label: 'Garantia'},
                { Value : statusReparo_ID,      Label: 'Status do Reparo'},                        
                { Value : defeito_ID,           Label: 'Defeito Encontrado'},
                { Value : statusAuditoria_ID,   Label: 'Status Auditoria'},
                { Value : valorTotal,           Label: 'Valor total do reparo'},
                { Value : statusFaturamento_ID, Label: 'Já foi faturado'},
                { Value : numeroPedido,         Label: 'Número do Pedido'},                        
                { Value : observacao,           Label: 'Observação'},
                { Value : statusOS,             Label: 'Status da OS'}
        ]}                                               
    }        
);


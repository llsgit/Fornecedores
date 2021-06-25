using OrdemService as service from '../../srv/ordem-service';

    extend  OrdemService.FiltrosPesquisa with @( 
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
            ],
            HeaderInfo : {
                TypeName       : 'Filtro de Pesquisa',
                TypeNamePlural : 'Filtros Pesquisa',
                TypeImageUrl   : 'sap-icon://document-text',
                Title          : {Value : empresa },
                Description    : {Value : cod_operacao }
            },        
            PresentationVariant : {
                SortOrder : [
                    {
                        $Type : 'Common.SortOrderType',
                        Property : empresa,
                        Descending : true,
                    },
                ],
                Visualizations : ['@UI.LineItem']
            },                         
            Facets: [       
                {
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#FiltroData',
                    Label  : 'Filtro'
                }                
            ],
            FieldGroup #FiltroData : {
                Data : [ 
                    { Value: empresa },
                    { Value: cod_operacao }                    
                ]
            }        
        }        
    );


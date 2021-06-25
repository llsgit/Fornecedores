using OrdemService as service from '../../srv/ordem-service';

extend  OrdemService.CentroAreaCliente with @( 
    odata.draft.enabled,
    Capabilities : [ { DeleteRestrictions : {Deletable : false},
                        SearchRestrictions : {Searchable: false} } ],                     
    Common       : { Label : 'Centro x Área x Cliente'} ,
    UI: {
        SelectionFields : [  ID, cd, estado, areaCliente ],   
        LineItem: [
            { Value: ID},
            { Value: cd},
            { Value: estado},
            { Value: areaCliente}
        ],
        HeaderInfo : {
            TypeName       : 'Centro x Área x Cliente',
            TypeNamePlural : 'Centro x Área x Clientes',
            TypeImageUrl   : 'sap-icon://document-text',
            Title          : {Label: 'Centro', Value : ID },
            Description    : {Label: 'Area', Value : areaCliente }
        },        
        PresentationVariant : {
            SortOrder : [
                {
                    $Type : 'Common.SortOrderType',
                    Property : ID,
                    Descending : true,
                },
            ],
            Visualizations : ['@UI.LineItem']
        },                         
        Facets: [       
            {
                $Type  : 'UI.ReferenceFacet',
                Target : '@UI.FieldGroup#CentroData',
                Label  : 'Centro'
            }                
        ],
        FieldGroup #CentroData : {
            Data : [ 
                { Value: ID,                    Label: 'Centro'},
                { Value: cd,                    Label: 'Centro Distribuição'},
                { Value: estado,                Label: 'Estado'},
                { Value: areaCliente,           Label: 'Área Cliente'}                    
            ]
        }          
    }
);   
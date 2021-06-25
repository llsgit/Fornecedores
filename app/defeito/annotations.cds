using OrdemService as service from '../../srv/ordem-service';

    extend  OrdemService.Defeitos with @( 
        odata.draft.enabled,
        Capabilities : [ { DeleteRestrictions : {Deletable : true},
                           UpdateRestrictions:  {Updatable: false},
                           SearchRestrictions : {Searchable: false} } ],                     
        Common       : { Label : 'Defeitos'} ,
        UI: {
            SelectionFields : [  ID, name],   
            LineItem: [                
                { Value: name},
                { Value: ID}               
            ],
            HeaderInfo : {
                TypeName       : 'Defeito',
                TypeNamePlural : 'Defeitos',
                TypeImageUrl   : 'sap-icon://document-text',
                Title          : {Value : ID }
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
                    Target : '@UI.FieldGroup#FiltroData',
                    Label  : 'Defeito'
                }                
            ],
            FieldGroup #FiltroData : {
                Data : [ 
                    { Value: ID },
                    { Value: name }
                ]
            }        
        }        
    );


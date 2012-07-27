package com.ci.util.j2f
{
	import mx.collections.ArrayCollection;

	/** 
	 * This compact library maps JSON objects to Flex AS objects
	 * Requirements: JSON objects need to have "className" property
	 * defined for every JSON object. className should be the full path 
	 * (e.g. ci.ps.model.Province) to flex vo/model objects
	 * mapToAsObject takes JSON decoded object and returns typed AS Object
	 * 
	 * Creator : Muhammad Noman (mnoman@ci.com)
	 * Date: July 27, 2012
	 * version: 0.1
	 * 
	 */
	
	
	
	public class JsonToFlex
	{
		import flash.utils.describeType;
		import flash.utils.getDefinitionByName;
		import flash.utils.getQualifiedClassName;
		
		
		public function JsonToFlex()
		{// empty constructor for now
		}
		
		public static function mapToASObjects(jsonObj:Object, isDebug:Boolean=false):Object 
		{
			var classObj:Class;
			var returnAmfObject:Object;
			
			try
			{
				classObj = getDefinitionByName(jsonObj.className) as Class;
				returnAmfObject = new (classObj)();
			}
			catch(error:ReferenceError)	// could not find the class
			{
				trace( error );
			}
			
			
			if( classObj != null && returnAmfObject != null)	// proceed only if no errors
			{
				var propertyMap:XML = describeType(returnAmfObject);
				var propertyTypeClass:Class;
				var tempPtcObj:Object;
				
				// loop over the structure
				for each (var property:XML in propertyMap.variable) 
				{
					if ((jsonObj as Object).hasOwnProperty(property.@name)) 
					{
						
						// if Array; loop over it and recurse
						// if primitive property (e.g. int, string, boolean etc); simply copy value to AS Object
						// if Object; recurse
						
						propertyTypeClass = getDefinitionByName(property.@type) as Class;
						tempPtcObj = new (propertyTypeClass)();
						
						// if primitive types
						if( tempPtcObj is String || tempPtcObj is int || tempPtcObj is uint || tempPtcObj is Boolean)	
						{
							if( jsonObj[property.@name] is propertyTypeClass)	// Make sure jsonObject property and AS Object property TYPES match
							{
								returnAmfObject[property.@name] = jsonObj[property.@name];
								isDebug ? trace(jsonObj.className + ':  property is ' + property.@name) : false;
							}
							else
							{
								isDebug ? trace('Error: Property types do not match <' + property.@name + '>   <'+ property.@type + '>  ' + jsonObj[property.@name]) : false;
							}
						}
							
							//-- Array
						else if ( jsonObj[property.@name] is Array) 	
						{
							isDebug ? trace('Info: (recursive call ahead) Property is Array : <' + property.@name + '>') : 	false; 
							
							var arr:ArrayCollection = new ArrayCollection(new Array());
							for each (var item:Object in (jsonObj[property.@name] as Array))
							{
								if( (item is String) || (item is int) || (item is Boolean) || (item is uint)  )
									arr.addItem( item );
								else
									arr.addItem( mapToASObjects( item, isDebug ) ); 
							}
							returnAmfObject[property.@name] = arr.length > 0 ? arr : null;
						} 
							
							//-- Object
						else if( jsonObj[property.@name] is Object) 	
						{		
							isDebug ? trace( 'Info: (recursive call ahead) Property is Object <' + jsonObj[property.@name]+'>') : false;
							returnAmfObject[property.@name] = mapToASObjects( jsonObj[property.@name] as Object , isDebug);
						}						
						else
						{
							isDebug ? trace('Error: Property is unknown type : <' + property.@name + '>  <' + property.@type + '>') : false;
						}
						
					}
					else // error
					{
						isDebug ? trace('Error: Can not map property <' + property.@name + '>') : false;
						returnAmfObject = null;
						//break;
					}
				}
			}
			return returnAmfObject;
		}

	}
}
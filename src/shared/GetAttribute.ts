/* eslint-disable prettier/prettier */

export function GetAttribute<T>(object: Instance, attribute: string, defaultAttribute: T, mustExist?: Boolean): T {
    const foundAttribute = object.GetAttribute(attribute);
    const expectedType = typeOf(defaultAttribute);
    const actualType = typeOf(foundAttribute);
    
    if (foundAttribute === undefined) {
		assert(!mustExist, `${object.GetFullName()} missing attribute ${attribute} (must be a ${expectedType})!`);
        object.SetAttribute(attribute, defaultAttribute as AttributeValue);
        return defaultAttribute;
    }

	assert(actualType === expectedType, `${object.GetFullName()} ${attribute} attribute has type ${actualType}, expected ${expectedType}`)

    return foundAttribute as T;
}
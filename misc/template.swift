// UnkeyedBegin
<% types.each do |type| %>
    <%= inline %>public func decode(_ type: <%= type %>.Type) throws -> <%= type %> {
        try ensureArrayIsNotAtEnd()
        let decoded = decoder.unbox(currentValue, as: <%= type %>.self)
        advanceArray()
        return decoded
    }

<% end %>
// UnboxBegin
<% types.each do |type| %>
    <%= inline %>fileprivate func unbox(_ value: Value, as type: <%= type %>.Type) -> <%= type %> {
        let result = JNTDocumentDecode__<%= c_type(type) %>(value)
<% if type == "String" %>
        if result == nil {
            return ""
        }
<% end %>
        return <%= convert(type) %>
    }

<% end %>
// SingleValueBegin
<% types.each do |type| %>
    public func decode(_ type: <%= type %>.Type) -> <%= type %> {
        return unbox(containers.topContainer, as: <%= type %>.self)
    }

<% end %>
// KeyedBegin
<% (types + ["T"]).each do |type| %>
    <%= inline %>fileprivate func decode<%= type == "T" ? "<T : Decodable>" : "" %>(_ type: <%= type %>.Type, forKey key: K) <%= throws(type) %>-> <%= type %> {
        let subValue: Value = key.stringValue.withCString(fetchValue)
        return <%= try(type) %>decoder.unbox(subValue, as: <%= type %>.self)
    }

<% end %>

Omit: _
Omit: {
  orig: {...}
  pathsToOmit: _//{[_]: true | {} }
  //check if key set!!!
//  nestedOmits: { for k, v in orig {"/(k)": Omit & { orig: v, pathsToOmit: {
//    if (isKeySet & {struct: pathsToOmit, key: k}).result {
//      "\(k)": pathsToOmit[k]
//    }
//    if !(isKeySet & {struct: pathsToOmit, key: k}).result {
//      "\(k)": {}
//    }
//  }}}}
  //result: _
  result: {
    pathsToOmit_ = pathsToOmit
//  valueIsStruct: (isValueStruct & { value: v }).result
//  inPathToOmit: (isKeySet & {struct: pathsToOmit_, key: k}).result
//  pathToOmit: inPathToOmit && (isValueBool & {value: pathsToOmit_[k]}).result
    for k, v in orig if (!(isKeySet & {struct: pathsToOmit_, key: "\(k)"}).result || !(isValueBool & {value: pathsToOmit_[k]}).result) {
      if (isValueStruct & { value: v }).result {
        "\(k)": (Omit & { orig: v, pathsToOmit: pathsToOmit_[k]}).result
      }
      if !(isValueStruct & { value: v }).result {
        "\(k)": v
      }
    }
  }
}
//      let checks: {
//      }
//      if !checks.pathToOmit
//        { "\(k)": if checks.valueIsStruct then (nestedOmits & {"/(k)": _ })[k].result else v }

data: {a: 3, c: { d: 4 }, c: e: 5}
paths: {c: d: true}
dataOmitted: (Omit & { orig: data, pathsToOmit: paths }).result

test: {
  keySetFoo: (isKeySet & {struct: { ban: "something" }, key: "foo"}).result
  keySetBan: (isKeySet & {struct: { ban: "something" }, key: "ban"}).result
  keySetFooStruct: (isKeySet & {struct: { ban: { asdfafoo: "something"} }, key: "foo"}).result
  keySetBanStruct: (isKeySet & {struct: { ban: { asdfasfoo: "something"} }, key: "ban"}).result
  keySetBanStruct: (isKeySet & {struct: { ban: { asdfasfoo: "something"} }, key: "ban"}).result
  keySetBanStructAnything: (isKeySet & {struct: { ban: _ }, key: "ban"}).result
  keySetPathThing: (isKeySet & {struct: paths, key: "c"}).result

}

isKeySet:: {
  struct: {...} // set the key we're checking
  key: string
  result: (struct & {[_]: _ | *_|_})[key] != _|_
}

isValueStruct:: {
  value: _
  result: ((value & {}) | *_|_) != _|_
}

isValueBool:: {
  value: _
  result: ((value & bool) | *_|_) != _|_
}

test: {
  isValueStructStruct: (isValueStruct & { value: { foo: "bar" } }).result
  isValueStructNull: (isValueStruct & { value: null }).result
  isValueStructInt: (isValueStruct & { value: int }).result
  isValueStructInt4: (isValueStruct & { value: 4 }).result
  isValueStructString: (isValueStruct & { value: "foo" }).result
  isValueStructBool: (isValueStruct & { value: bool }).result

  isValueBoolBoolBool: (isValueBool & { value: true }).result
  isValueBoolBoolStruct: (isValueBool & { value: { foo: "bar" } }).result
  isValueBoolStruct: (isValueBool & { value: { foo: "bar" } }).result
  isValueBoolNull: (isValueBool & { value: null }).result
  isValueBoolInt: (isValueBool & { value: int }).result
  isValueBoolInt4: (isValueBool & { value: 4 }).result
  isValueBoolString: (isValueBool & { value: "foo" }).result

}

something: 5 & {}

//keysetstruct: { [key=_]: (struct & {[_]: _ | *_|_})[key] != _|_ }

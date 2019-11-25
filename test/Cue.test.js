const test = require('tape');

const { Cue } = require('../src');

test('Cue', (t) => {
  t.test('MarshallJSON', async (assert) => {
    const cue = new Cue()
    const instance = await cue.compile('test', 'foo: "bar"');
    const value = await instance.value();
    const json = await value.marshalJSON();
    assert.equal(
      json,
      '{"foo":"bar"}'
    );
    assert.end();
  });
});

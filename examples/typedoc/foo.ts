export type MyString = string;

export class Foo {
  public bar(): void {}
  public baz(): MyString {
    return "Hello World";
  }
}

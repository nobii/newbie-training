Ruby
====

Rubyによるオブジェクト指向プログラミング的な資料はまだない。ほしい。

課題1
====
`spec/sort_spec.rb`を各自のディレクトリにcopyしてテストが通るように`lib/sorter.rb`を実装してください。

テスト実行

```
$ tree
.
├── README.md
├── lib
│   └── sorter.rb
└── spec
    └── sort_spec.rb
$ rspec -c -f d spec/sort_spec.rb

Sorter Class
  initialize
    can be instanciated
  values
    is initialized by empty array
    can be set empty value
    can be set single value
    can be set multiple values
  sort
    can sort empty value
    can sort single value
    can sort multiple values
    sort random values

Finished in 0.00213 seconds (files took 0.08586 seconds to load)
9 examples, 0 failures
```

課題2
====
下記のインターフェースを満たす`My::List`とそのテストを作成してください。

```
list = My::List.new

list.append('Hello')
list.append('World')
list.append(2008)

iter = list.iterator
while iter.has_next do
  p iter.next.value
end
```

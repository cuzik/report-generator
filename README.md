# Report Generator

Report Generator to .csv OiTchau


## Requisitos
```sh
gem install bundler
```

```sh
bundle install
```


## Steps

### Put the `.xlsx` file on `./data/` folder

### Run `preprocessor.rb` to fix export by OiTchau.com

```sh
bundle exec ruby preprocessor.rb
```

### Review files inside of `./data_csv/`

### Run `report.rb` to generate the report day by day of your `punches`

```sh
bundle exec ruby report.rb
```

### See the all reports on `./report_csv/` and the shell output

module Agents
  class AnomalyAgent < Agent
    include FormConfigurable
    cannot_be_scheduled!

    gem_dependency_check { defined?(IsoTree::IsolationForest) }

    description <<-MD
      Anomaly Agent trains an isotree model to detect anomalies in a series of Huginn events. For a full description of options please see https://isotree.readthedocs.io/en/latest/#isotree.IsolationForest
    MD

    def default_options
      {
        categ_outliers: "tail",
        categ_split: "binarize",
        expected_update_period_in_days: "2",
        follow_all: false,
        gain_as_pct: true,
        max_depth: 4,
        min_gain: 0.01,
        min_size_categ: 50,
        min_size_numeric: 25,
        model_file: "model.bin",
        nthreads: -1,
        numeric_split: "raw",
        pct_outliers: 0.01,
        z_norm: 2.67,
        z_outlier: 8.0,
      }
    end

    form_configurable :max_depth
    form_configurable :min_gain
    form_configurable :z_norm
    form_configurable :z_outlier
    form_configurable :pct_outliers
    form_configurable :min_size_numeric
    form_configurable :min_size_categ
    form_configurable :categ_split, type: :string
    form_configurable :categ_outliers, type: :string
    form_configurable :numeric_split, type: :string
    form_configurable :follow_all, type: :boolean
    form_configurable :gain_as_pct, type: :boolean
    form_configurable :nthreads
    form_configurable :expected_update_period_in_days
    form_configurable :model_file, type: :string


    # def validate_options
    # end

    def working?
      received_event_without_error?
    end

    def receive(incoming_events)
      create_event payload: model.predict(incoming_events)

      model.fit(incoming_events)

      model.export_model(options[:model_file])
    end

    def model
      if File.exist?(options[:model_file])
        @model.load(options[:model_file])
        @model = IsoTree::IsolationForest.import_model(options[:model_file])
      else
        @model = IsoTree::IsolationForest.new
      end

      return @model
    end
  end
end

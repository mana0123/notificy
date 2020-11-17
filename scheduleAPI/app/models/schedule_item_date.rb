class ScheduleItemDate < ApplicationRecord

  # year : integer
  # month : integer
  # week : integer (2桁:　
  #                  1桁目 曜日　⇒　1:月,2:火,・・・,7:日
  #                  2桁目 第何曜日　⇒　0:毎週,1:第一,・・・,5:第五)
  # day : integer
  # hour : integer

  # 通知日のルール
  #  ・1回(繰り返しなし)の場合
  #    year,month,day,hourを数値で埋める
  #  ・繰り返しの場合
  #    毎年⇒yearをnil
  #    毎月⇒monthをnil
  #    毎週⇒weekを指定
  #  ・複数指定もあり

  validates :week, presence: true,
                   numericality: { only_integer: true },
                   allow_nil: true
  validates :year, presence: true,
                   numericality: { only_integer: true },
                   inclusion: { in: 2000..9999 },
                   allow_nil: true
  validates :month, presence: true,
                    numericality: { only_integer: true },
                    inclusion: { in: 1..12 },
                    allow_nil: true
  validates :day, presence: true,
                  numericality: { only_integer: true },
                  allow_nil: true
  validates :hour, presence: true,
                   numericality: { only_integer: true },
                   inclusion: { in: 0..23 },
                   allow_nil: true
  
  validate  :week_format_valid
  validate  :date_format_valid

  belongs_to :schedule_item

  private
    # weekのフォーマットチェック
    def week_format_valid
      return true if week.blank?

      if week.present? && day.present?
        error_msg = "weekとdayは同時に指定できません"
        errors.add(:week, error_msg)
        return false
      end

      (1..7).each do |n|
        if week.between?( n * 10, n * 10 + 5)
          return true
        end
      end

      error_msg = "weekが範囲外です"
      errors.add(:week, error_msg)
      return false

    end

    # 日付のフォーマットチェック
    def date_format_valid
      y = year || 2020
      m = month || 1
      d = day || 1
      begin
        Date.parse "#{y}/#{m}/#{d}"
      rescue ArgumentError
        error_msg = "不正な日付です:#{y}/#{m}/#{d}"
        errors.add(:year, error_msg)
      end
    end

end

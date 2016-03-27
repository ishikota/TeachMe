FactoryGirl.define do
  factory :user do
    name "Kota Ishimoto"
    student_id "A1178086"
    password "foobar"
    password_confirmation "foobar"
    
    factory :kota do
      name "kota"
      student_id "A1178086"
    end

    factory :ishimoto do
      name "ishimoto"
      student_id "B1578048"
    end

    factory :taro do
      name "taro"
      student_id "A1111111"
    end

    factory :admin do
      name "admin taro"
      student_id "A0000000"
      admin true
    end
  end
  
  factory :lesson do
    title "hoge"
    day_of_week 0
    period 1

    factory :sansu do
      title "算数"
      day_of_week 0
      period 1
    end

    factory :kokugo do
      title "国語"
      day_of_week 1
      period 2
    end
  end

  factory :tag do
    factory :tashizan do
      name "足し算"
    end
    factory :hikizan do
      name "引き算"
    end
    factory :kakezan do
      name "掛け算"
    end
  end
end

import {
  AnimatedNumber,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
} from 'tgui-core/components';
import { formatMoney } from 'tgui-core/format';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  current_balance: number;
  withdrawal_amount: number;
  totalcreds: number;
};

export const AutoBank = (props) => {
  const { act, data } = useBackend<Data>();
  const { current_balance, withdrawal_amount } = data;

  return (
    <Window width={350} height={155}>
      <Window.Content>
        <NoticeBox danger>CONNECTING. . .</NoticeBox>
        <Section title={'Port Authority Currency Terminal'}>
          <LabeledList>
            <LabeledList.Item
              label="CURRENT BALANCE"
              buttons={
                <NumberInput
                  value={0}
                  minValue={0}
                  maxValue={100000}
                  step={1}
                  onChange={(value) =>
                    act('withdraw', {
                      totalcreds: value,
                    })
                  }
                />
              }
            >
              <AnimatedNumber
                value={current_balance}
                format={(value) => formatMoney(value)}
              />
              {' ♎︎'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

import type { CSSProperties, Dispatch, ReactNode, SetStateAction } from 'react'; // DOPPLER EDIT ADDITION: Adds suport for recoloring header buttons. Was previously: import type { Dispatch, ReactNode, SetStateAction } from 'react';
import { Button } from 'tgui-core/components';

type Props<TPage> = {
  currentPage: TPage;
  page: TPage;
  otherActivePages?: TPage[];
  setPage: Dispatch<SetStateAction<TPage>>;
  children?: ReactNode;
  activeStyle?: CSSProperties; // DOPPLER EDIT ADDITION: Adds suport for recoloring header buttons
};

export function PageButton<TPage extends number>(props: Props<TPage>) {
  const {activeStyle, children, currentPage, page, otherActivePages, setPage} = props; // DOPPLER EDIT ADDITION: Adds suport for recoloring header buttons. Was previously:  const { children, currentPage, page, otherActivePages, setPage } = props;

  const pageIsActive =
    currentPage === page ||
    (otherActivePages && otherActivePages.indexOf(currentPage) !== -1);

  return (
    <Button
      align="center"
      fontSize="1.2em"
      fluid
      selected={pageIsActive}
      onClick={() => setPage(page)}
      style={pageIsActive ? activeStyle : undefined} // DOPPLER EDIT ADDITION: Adds suport for recoloring header buttons.
    >
      {children}
    </Button>
  );
}
